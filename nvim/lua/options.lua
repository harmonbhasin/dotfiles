--- Neovim editor options and global settings
--- Configures core editor behavior, display preferences, and language defaults

vim.g.python_recommended_style = 0
vim.g.markdown_recommended_style = 0

vim.wo.number = true
vim.g.mapleader = " "
vim.opt.relativenumber = true
vim.opt.tabstop = 2 -- Number of spaces that a <Tab> in the file counts for
vim.opt.shiftwidth = 2 -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.smartindent = true -- Make indenting smarter again
vim.opt.autoindent = true -- Auto indent
vim.opt.syntax = "on" -- Enable syntax highlighting
vim.opt.showmode = false -- Don't show mode in command line
vim.opt.showtabline = 0 --remove tabline

-- Make Fugitive use Git's configured pager (Delta)
vim.g.fugitive_use_git_pager = 1

-- Make Fugitive status window take 25% of screen height
vim.api.nvim_create_autocmd("FileType", {
	pattern = "fugitive",
	callback = function()
		vim.cmd("resize " .. math.floor(vim.o.lines * 0.25))
	end,
})

-- Set conceallevel for obsidian (conditionally set in setup.lua)
vim.opt.conceallevel = 1
