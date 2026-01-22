require("config.lazy")

local function Set_Options()
    vim.opt.relativenumber = false

    vim.cmd("set noexpandtab")
    vim.opt.tabstop = 4
    vim.opt.shiftwidth = 4

    vim.opt.wrap = false

    vim.opt.swapfile = false
    vim.opt.backup = false

    vim.opt.updatetime = 50
end

local function roblox_project()
    return vim.fs.root(0, function(name)
        return name:match(".+%.project%.json$")
    end)
end

if roblox_project() then
    vim.fn.jobstart("rojo serve", {
        on_stdout = function(_, data)
            if data then
                print(vim.inspect(data))
            end
        end,
        on_stderr = function(_, data)
            if data then
                print(vim.inspect(data))
            end
        end,
        on_exit = function(_, exit_code)
            print("Rojo serve exited with code: " .. exit_code)
        end,
    })
end

require("luau-lsp").setup({
    plugin = {
        enabled = true,
        port = 3667,
    },
    types = {
        plugin_security_level = "PluginSecurity",
    },
    platform = {
        type = roblox_project() and "roblox" or "standard",
    },
    sourcemap = {
        enabled = true,
        autogenerate = true,
        rojo_project_file = "default.project.json",
        sourcemap_file = "sourcemap.json",
    },
    fflags = {
        enable_new_solver = false,
        sync = true,
        override = {},
    },
    server = {
        path = "luau-lsp",
    },
})

local servers = {
    ["rust-analyzer"] = {},
    clangd = {},
    lua_ls = {
        on_init = function(client)
            if client.workspace_folders then
                local path = client.workspace_folders[1].name
                if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
                    return
                end
            end

            client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                runtime = {
                    version = "LuaJIT",
                },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME,
                    },
                },
            })
        end,
        settings = {
            Lua = {},
        },
    },
}

vim.lsp.config("luau-lsp", {
    settings = {
        ["luau-lsp"] = {
            completion = {
                enabled = true,
                autocomplete = true,
                autocompleteEnd = true,
                fillCallArguments = false,
                addParentheses = true,
                imports = {
                    enabled = true,
                    requireStyle = "alwaysAbsolute",
                },
            },
            inlayHints = {
                functionReturnTypes = true,
                parameterTypes = true,
            },
        },
    },
    on_attach = function(client, bufnr)
        require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
    end,
})

for server, config in pairs(servers) do
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    vim.lsp.config[server] = config
    vim.lsp.enable(server)
end
vim.lsp.config("*", {
    capabilities = {
        workspace = {
            didChangeWatchedFiles = {
                dynamicRegistration = true,
            },
        },
        diagnosticProvider = {
            workspaceDiagnostics = true,
        },
    },
})
