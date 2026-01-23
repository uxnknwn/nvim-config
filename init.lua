local function set_options()
    vim.opt.relativenumber = false
    vim.cmd("set noexpandtab")
    vim.opt.tabstop = 4
    vim.opt.shiftwidth = 4
    vim.opt.wrap = false
    vim.opt.swapfile = false
    vim.opt.backup = false
    vim.opt.updatetime = 50
    vim.diagnostic.config({
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = "",
                [vim.diagnostic.severity.WARN] = "",
                [vim.diagnostic.severity.HINT] = "",
                [vim.diagnostic.severity.INFO] = "",
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
            source = "always",
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

local function setup_lazy()
    require("lazy").setup({
        spec = {
            { import = "plugin" },
        },
        install = { colorscheme = { "catppuccin-mocha" } },
        checker = { enabled = true },
    })
end

set_options()
install_lazy()
setup_leaders()
setup_lazy()
