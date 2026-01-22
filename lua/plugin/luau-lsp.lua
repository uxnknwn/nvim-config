local lspconfig = require("lspconfig")

local function is_roblox_project()
    return vim.fs.root(0, function(name)
        return name:match(".+%.project%.json$")
    end)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.workspace.didChangeWatchedFiles = { dynamicRegistration = true }
capabilities.diagnosticProvider = { workspaceDiagnostics = true }

local function on_attach(client, bufnr)
    if require("workspace-diagnostics") then
        require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
    end
end

-- Luau LSP setup
lspconfig.luau_lsp.setup({
    settings = {
        luau = {
            platform = is_roblox_project() and "roblox" or "standard",
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
            sourcemap = {
                enabled = true,
                autogenerate = false,
                rojo_project_file = "default.project.json",
                sourcemap_file = "sourcemap.json",
            },
            plugin = {
                enabled = false,
                port = 3667,
            },
            fflags = {
                enable_new_solver = false,
                sync = true,
                override = {},
            },
        },
    },
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "luau-lsp" },
})
