return {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "debugloop/telescope-undo.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
        require("telescope").setup({})

        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "Telescope find files" })
        vim.keymap.set("n", "<leader>g", builtin.live_grep, { desc = "Telescope live grep" })
        vim.keymap.set("n", "<leader>h", builtin.buffers, { desc = "Telescope buffers" })
        vim.keymap.set("n", "<leader>j", builtin.help_tags, { desc = "Telescope help tags" })
    end,
}
