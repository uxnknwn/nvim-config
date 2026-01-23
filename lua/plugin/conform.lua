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
                typescript = { "prettierd", "prettier" },
                typescriptreact = { "prettierd", "prettier" },
                css = { "prettierd", "prettier" },
                cpp = { "clang-format" },
                toml = { "taplo" },
                json = { "prettier" },
                ocaml = { "ocamlformat" },
            },
            format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
            default_format_opts = { lsp_format = "fallback" },
        })
    end,
}
