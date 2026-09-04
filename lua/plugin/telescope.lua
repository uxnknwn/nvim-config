return {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    cmd = "Telescope",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "debugloop/telescope-undo.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
        { "<leader>f", "<cmd>Telescope find_files<cr>", desc = "Telescope find files" },
        { "<leader>g", "<cmd>Telescope live_grep<cr>", desc = "Telescope live grep" },
        { "<leader>h", "<cmd>Telescope buffers<cr>", desc = "Telescope buffers" },
        { "<leader>j", "<cmd>Telescope help_tags<cr>", desc = "Telescope help tags" },
        { "<leader>u", "<cmd>Telescope undo<cr>", desc = "Telescope undo history" },
    },
    config = function()
        local telescope = require("telescope")

        telescope.setup({})

        pcall(telescope.load_extension, "fzf")
        pcall(telescope.load_extension, "undo")
    end,
}
