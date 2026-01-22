require("config.lazy")

local function Set_Options()
    vim.opt.relativenumber = false
    vim.cmd("set noexpandtab")
    vim.opt.tabstop = 4
    vim.opt.shiftwidth = 4
    vim.opt.wrap = false
    vim.opt.swapfile = false
    vim.opt.backup = false
    vim.opt.updatetime = 50
end
