return {
    "stevearc/conform.nvim",
    lazy = false,
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
                luau = { "stylua" },
                python = { "isort", "black" },
                rust = { "rustfmt", lsp_format = "fallback" },
                javascript = { "prettierd", "prettier", stop_after_first = true },
                typescript = { "prettierd", "prettier", stop_after_first = true },
                typescriptreact = { "prettierd", "prettier", stop_after_first = true },
                css = { "prettierd", "prettier", stop_after_first = true },
                cpp = { "clang-format" },
                toml = { "taplo" },
                json = { "prettier" },
            },
            format_on_save = function(bufnr)
                local filetype = vim.bo[bufnr].filetype

                if
                    (filetype == "lua" or filetype == "luau")
                    and not vim.fs.root(bufnr, { "stylua.toml", ".stylua.toml" })
                then
                    return nil
                end

                return { timeout_ms = 500, lsp_format = "fallback" }
            end,
            default_format_opts = { lsp_format = "fallback" },
        })
    end,
}
