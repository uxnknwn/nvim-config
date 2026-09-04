return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        spec = {
            { "<leader>d", group = "Diagnostics" },
            { "<leader>e", group = "Errors" },
            { "<leader>w", group = "Warnings" },
            { "<leader>c", group = "Codex" },
            { "<leader>G", group = "Git" },
            { "<leader>x", group = "Trouble" },
            { "<leader>q", group = "Session" },
        },
    },
}
