require("plugins")

-- disable netrw at the very start of your init.lua (Nvim tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.wo.relativenumber = true
vim.opt.tabstop = 2       -- Number of spaces that a <Tab> in the file counts for
vim.opt.shiftwidth = 2    -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true  -- Use spaces instead of tabs
vim.opt.syntax = "on"     -- Enable syntax highlighting
vim.opt.termguicolors = true -- Enable 24-bit RGB color in the terminal
vim.cmd 'colorscheme torte'

require("feline").setup()
require("nvim-tree").setup()
