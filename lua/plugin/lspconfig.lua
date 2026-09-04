local SERVERS = {
    "lua_ls",
    "pyright",
    "rust_analyzer",
    "clangd",
    "jsonls",
}

return {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
        if ok then
            capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
        end

        vim.lsp.config("*", {
            capabilities = vim.tbl_deep_extend("force", capabilities, {
                workspace = {
                    didChangeWatchedFiles = { dynamicRegistration = true },
                    diagnosticProvider = { workspaceDiagnostics = true },
                },
            }),
        })

        vim.lsp.enable(SERVERS)
    end,
}
