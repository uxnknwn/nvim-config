return {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "vimdoc",
                "javascript",
                "luau",
                "typescript",
                "ocaml",
                "c",
                "lua",
                "toml",
                "json",
                "vim",
                "query",
                "markdown",
                "markdown_inline",
            },

            sync_install = false,
            auto_install = true,

            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
        })
    end,
}
