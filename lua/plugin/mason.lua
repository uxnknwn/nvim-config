local TOOLS = {
    "stylua",
    "black",
    "isort",
    "rustfmt",
    "prettier",
    "prettierd",
    "clang-format",
    "taplo",

    "lua-language-server",
    "pyright",
    "rust-analyzer",
    "clangd",
    "json-lsp",

    "flake8",
    "luacheck",
    "selene",
}

return {
    {
        "mason-org/mason.nvim",
        lazy = false,
        priority = 100,
        config = function()
            require("mason").setup()
        end,
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        lazy = false,
        dependencies = { "mason-org/mason.nvim" },
        config = function()
            require("mason-tool-installer").setup({
                ensure_installed = TOOLS,
                run_on_start = true,
                start_delay = 2000,
            })
        end,
    },
}
