local CAPTURES = {
    ["]f"] = { capture = "@function.outer", backward = false, desc = "Next Function" },
    ["[f"] = { capture = "@function.outer", backward = true, desc = "Previous Function" },
    ["]]"] = { capture = "@class.outer", backward = false, desc = "Next Table" },
    ["[["] = { capture = "@class.outer", backward = true, desc = "Previous Table" },
}

local function jump(capture, backward)
    local bufnr = vim.api.nvim_get_current_buf()
    local lang = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
    if not lang then
        return
    end

    local ok, parser = pcall(vim.treesitter.get_parser, bufnr, lang)
    if not ok or not parser then
        return
    end

    local query = vim.treesitter.query.get(lang, "textobjects")
    local tree = parser:parse()[1]
    if not query or not tree then
        return
    end

    local cursor = vim.api.nvim_win_get_cursor(0)
    local crow, ccol = cursor[1] - 1, cursor[2]
    local targets = {}

    for id, node in query:iter_captures(tree:root(), bufnr, 0, -1) do
        if query.captures[id] == capture:sub(2) then
            local srow, scol = node:range()
            targets[#targets + 1] = { srow, scol }
        end
    end

    table.sort(targets, function(a, b)
        if a[1] ~= b[1] then
            return a[1] < b[1]
        end
        return a[2] < b[2]
    end)

    local best
    for _, t in ipairs(targets) do
        local before = t[1] < crow or (t[1] == crow and t[2] < ccol)
        local after = t[1] > crow or (t[1] == crow and t[2] > ccol)
        if backward and before then
            best = t
        elseif not backward and after then
            best = t
            break
        end
    end

    if best then
        vim.cmd("normal! m'")
        vim.api.nvim_win_set_cursor(0, { best[1] + 1, best[2] })
    end
end

return {
    "echasnovski/mini.ai",
    version = "*",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        local ai = require("mini.ai")

        ai.setup({
            n_lines = 500,
            custom_textobjects = {
                f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
                c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
                a = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
                o = ai.gen_spec.treesitter({
                    a = { "@conditional.outer", "@loop.outer" },
                    i = { "@conditional.inner", "@loop.inner" },
                }),
            },
        })

        for lhs, spec in pairs(CAPTURES) do
            vim.keymap.set({ "n", "x", "o" }, lhs, function()
                jump(spec.capture, spec.backward)
            end, { desc = spec.desc })
        end
    end,
}
