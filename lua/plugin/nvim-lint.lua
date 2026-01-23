return {
    "mfussenegger/nvim-lint",
    lazy = false,
    config = function()
        require("lint").linters_by_ft = {
            lua = { "selene" },
            luau = { "selene" },
        }
        vim.api.nvim_create_autocmd({ "BufRead", "BufWritePost", "InsertLeave" }, {
            callback = function()
                require("lint").try_lint()
            end,
        })
    end,
}
