return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("lualine").setup({
            options = {
                theme = "auto",
                globalstatus = true,
                component_separators = "",
                section_separators = "",
            },
            sections = {
                lualine_c = { { "filename", path = 1 } },
                lualine_x = { "diagnostics", "filetype" },
            },
        })
    end,
}
