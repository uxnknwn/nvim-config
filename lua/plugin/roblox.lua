local function roblox_project()
    return vim.fs.root(0, function(name)
        return name:match(".+%.project%.json$")
    end)
end

if roblox_project() then
    vim.filetype.add({
        extension = {
            lua = function(path)
                return path:match("%.nvim%.lua$") and "lua" or "luau"
            end,
        },
    })
end

return {
    "lopi-py/luau-lsp.nvim",
    lazy = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("luau-lsp").setup({
            plugin = { enabled = false, port = 3667 },
            types = { plugin_security_level = "PluginSecurity" },
            platform = { type = roblox_project() and "roblox" or "standard" },
            sourcemap = {
                enabled = true,
                autogenerate = false,
                rojo_project_file = "default.project.json",
                sourcemap_file = "sourcemap.json",
            },
            fflags = { enable_new_solver = true, sync = true, override = {} },
            server = { path = vim.fn.stdpath("data") .. "/mason/bin/luau-lsp" },
        })

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
        if ok then
            capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
        end

        vim.lsp.config("*", {
            capabilities = {
                workspace = {
                    didChangeWatchedFiles = { dynamicRegistration = true },
                    diagnosticProvider = { workspaceDiagnostics = true },
                },
            },
        })

        vim.lsp.config("luau-lsp", {
            capabilities = capabilities,
            settings = {
                ["luau-lsp"] = {
                    completion = {
                        enabled = true,
                        autocomplete = true,
                        autocompleteEnd = true,
                        fillCallArguments = false,
                        addParentheses = true,
                        imports = { enabled = true, requireStyle = "alwaysAbsolute" },
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

        local function run_sourcemap()
            local scripts_dir = vim.fs.find("scripts", { upward = true })[1]
            local script = scripts_dir and scripts_dir .. "/sourcemap.sh"

            if script and vim.fn.filereadable(script) == 1 then
                vim.fn.jobstart({ "bash", script }, {
                    stdout_buffered = true,
                    stderr_buffered = true,
                    on_exit = function(_, code, _)
                        if code ~= 0 then
                            local output = vim.fn.systemlist("bash " .. script)
                            vim.notify("Sourcemap failed:\n" .. table.concat(output, "\n"), vim.log.levels.ERROR)
                        end
                    end,
                })
            else
                vim.notify("sourcemap.sh not found in scripts folder", vim.log.levels.WARN)
            end
        end

        vim.api.nvim_create_autocmd("BufWritePost", {
            pattern = { "*.lua", "*.luau" },
            callback = function()
                if roblox_project() then
                    run_sourcemap()
                end
            end,
        })

        vim.api.nvim_create_autocmd("VimEnter", {
            callback = function()
                if roblox_project() then
                    run_sourcemap()
                end
            end,
        })
    end,
}
