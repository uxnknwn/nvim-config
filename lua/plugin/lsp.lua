return {
    {
        "lopi-py/luau-lsp.nvim",
        lazy = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {},
        config = function() end,
    },
    {
        "stevearc/conform.nvim",
        opts = {},
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    lua = { "stylua" },
                    luau = { "stylua" },
                    -- Conform will run multiple formatters sequentially
                    python = { "isort", "black" },
                    -- You can customize some of the format options for the filetype (:help conform.format)
                    rust = { "rustfmt", lsp_format = "fallback" },
                    -- Conform will run the first available formatter
                    javascript = { "prettierd", "prettier", stop_after_first = true },
                    ocaml = { "ocamlformat" },
                    typescript = { "prettierd", "prettier" },
                    typescriptreact = { "prettierd", "prettier" },
                    css = { "prettierd", "prettier" },
                    cpp = { "clang-format" },
                },

                default_format_opts = {
                    lsp_format = "fallback",
                },
            })

            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = { "*.lua", "*.luau" },
                callback = function()
                    require("conform").format({ async = false })
                end,
            })
        end,
    },
}
