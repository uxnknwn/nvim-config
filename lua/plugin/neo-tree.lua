return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
        },
        config = function()
            require("neo-tree").setup({
                enable_git_status = true,
                filesystem = {
                    filtered_items = {
                        hide_dotfiles = false,
                        hide_gitignored = false,
                    },
                },
                git_status = {
                    show_ignored = true,
                    show_untracked = true,
                },
                default_component_configs = {
                    git_status = {
                        symbols = {
                            -- Change type
                            added = "✚",
                            deleted = "✖",
                            modified = "",
                            renamed = "󰁕",
                            -- Status type
                            untracked = "",
                            ignored = "",
                            unstaged = "󰄱",
                            staged = "",
                            conflict = "",
                        },
                    },
                },
                event_handlers = {
                    {
                        event = "file_open_requested",
                        handler = function()
                            -- auto close
                            -- vim.cmd("Neotree close")
                            -- OR
                            require("neo-tree.command").execute({ action = "close" })
                        end,
                    },
                },
            })

            vim.api.nvim_set_keymap("n", "<C-n>", ":Neotree toggle<CR>", { noremap = true, silent = true })
        end,
    },
}
