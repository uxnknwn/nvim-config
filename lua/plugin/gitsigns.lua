return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("gitsigns").setup({
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },
            on_attach = function(bufnr)
                local gitsigns = require("gitsigns")

                local function map(lhs, rhs, desc)
                    vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
                end

                map("]c", function()
                    gitsigns.nav_hunk("next")
                end, "Next Hunk")
                map("[c", function()
                    gitsigns.nav_hunk("prev")
                end, "Previous Hunk")

                map("<leader>Gs", gitsigns.stage_hunk, "Stage Hunk")
                map("<leader>Gr", gitsigns.reset_hunk, "Reset Hunk")
                map("<leader>Gp", gitsigns.preview_hunk, "Preview Hunk")
                map("<leader>Gd", gitsigns.diffthis, "Diff This")
                map("<leader>Gb", function()
                    gitsigns.blame_line({ full = true })
                end, "Blame Line")
            end,
        })
    end,
}
