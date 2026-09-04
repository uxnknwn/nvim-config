local function set_options()
    vim.opt.number = true
    vim.opt.relativenumber = false
    vim.opt.expandtab = true
    vim.opt.tabstop = 4
    vim.opt.shiftwidth = 4
    vim.opt.wrap = false
    vim.opt.swapfile = false
    vim.opt.backup = false
    vim.opt.undofile = true
    vim.opt.updatetime = 50
    vim.opt.signcolumn = "yes"
    vim.opt.ignorecase = true
    vim.opt.smartcase = true
    vim.opt.scrolloff = 8
    vim.opt.splitright = true
    vim.opt.splitbelow = true
    vim.opt.clipboard = "unnamedplus"
    vim.diagnostic.config({
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = "",
                [vim.diagnostic.severity.WARN] = "",
                [vim.diagnostic.severity.HINT] = "",
                [vim.diagnostic.severity.INFO] = "",
            },
        },
        virtual_text = {
            prefix = "",
            spacing = 0,
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
            source = true,
            border = "rounded",
        },
    })
end

local function install_lazy()
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not (vim.uv or vim.loop).fs_stat(lazypath) then
        local lazyrepo = "https://github.com/folke/lazy.nvim.git"
        local out = vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "--branch=stable",
            lazyrepo,
            lazypath,
        })
        if vim.v.shell_error ~= 0 then
            vim.api.nvim_echo({
                { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
                { out, "WarningMsg" },
                { "\nPress any key to exit..." },
            }, true, {})
            vim.fn.getchar()
            os.exit(1)
        end
    end
    vim.opt.rtp:prepend(lazypath)
end

local function setup_leaders()
    vim.g.mapleader = " "
    vim.g.maplocalleader = "\\"
end

local function jump_to(count, severity)
    return function()
        vim.diagnostic.jump({ count = count, severity = severity, float = true })
    end
end

local function setup_keybinds()
    local severity = vim.diagnostic.severity

    vim.keymap.set("n", "<leader>dn", jump_to(1), { desc = "Next Diagnostic" })
    vim.keymap.set("n", "<leader>dp", jump_to(-1), { desc = "Previous Diagnostic" })

    vim.keymap.set("n", "<leader>en", jump_to(1, severity.ERROR), { desc = "Next Error" })
    vim.keymap.set("n", "<leader>ep", jump_to(-1, severity.ERROR), { desc = "Previous Error" })

    vim.keymap.set("n", "<leader>wn", jump_to(1, severity.WARN), { desc = "Next Warning" })
    vim.keymap.set("n", "<leader>wp", jump_to(-1, severity.WARN), { desc = "Previous Warning" })

    vim.keymap.set("n", "<leader>k", vim.diagnostic.open_float, { desc = "Show Diagnostic" })

    vim.keymap.set({ "n", "v" }, "<leader>F", function()
        require("conform").format({ async = true, lsp_format = "fallback" })
    end, { desc = "Format Buffer" })

    vim.keymap.set("n", "<leader>cc", function()
        vim.cmd("botright split | terminal codex")
    end, { desc = "Open Codex Terminal" })

    vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit Terminal Mode" })
end

local function setup_autocmds()
    vim.api.nvim_create_autocmd("TextYankPost", {
        group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
        callback = function()
            vim.hl.on_yank()
        end,
    })
end

local function setup_lazy()
    require("lazy").setup({
        spec = {
            { import = "plugin" },
        },
        install = { colorscheme = { "rasmus" } },
        checker = { enabled = true, notify = false },
    })
end

set_options()
install_lazy()
setup_leaders()
setup_keybinds()
setup_autocmds()
setup_lazy()
