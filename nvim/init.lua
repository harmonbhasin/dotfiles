-- TODO: Remove once plugins stop using vim.tbl_flatten
vim.deprecate = function() end

require("options")
require("plugins")
require("setup")
require("keymaps")
