local LINTERS = {
    python = { "flake8" },
    lua = { "luacheck" },
    luau = { "selene" },
}

local ROOT_MARKERS = {
    selene = { "selene.toml" },
    luacheck = { ".luacheckrc" },
}

local function resolve_cwd(bufnr, markers)
    local name = vim.api.nvim_buf_get_name(bufnr)
    if name == "" then
        return nil
    end

    local ok, root = pcall(vim.fs.root, name, markers)
    if not ok then
        return nil
    end
    return root
end

local function run_lint(bufnr)
    local lint = require("lint")
    local names = LINTERS[vim.bo[bufnr].filetype]
    if not names then
        return
    end

    for _, name in ipairs(names) do
        local linter = lint.linters[name]
        local markers = ROOT_MARKERS[name]
        if linter and markers then
            linter.cwd = resolve_cwd(bufnr, markers)
        end
    end

    lint.try_lint()
end

return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        require("lint").linters_by_ft = LINTERS

        vim.api.nvim_create_autocmd({ "FileType", "BufWritePost", "InsertLeave" }, {
            group = vim.api.nvim_create_augroup("nvim_lint", { clear = true }),
            callback = function(args)
                run_lint(args.buf)
            end,
        })

        local bufnr = vim.api.nvim_get_current_buf()
        vim.schedule(function()
            if vim.api.nvim_buf_is_valid(bufnr) then
                run_lint(bufnr)
            end
        end)
    end,
}
