return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    enabled = false,
    config = function()
        require("catppuccin").setup({
            flavour = "mocha",
            transparent_background = true,
            default_integrations = true,
            styles = {
                comments = { "italic" },
                conditionals = { "italic" },
            },
            integrations = {
                cmp = true,
                gitsigns = true,
                neotree = true,
                treesitter = true,
            },
        })

        vim.cmd.colorscheme("catppuccin")
    end,
}
