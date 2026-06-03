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

local function python_gf_includeexpr(fname)
	local resolved = fname
	local leading_dots = resolved:match("^%.+")

	if leading_dots then
		local rest = resolved:sub(#leading_dots + 1)
		if #leading_dots == 1 then
			resolved = "./" .. rest
		else
			resolved = string.rep("../", #leading_dots - 1) .. rest
		end
	end

	resolved = resolved:gsub("(%w)%.(%w)", "%1/%2")

	local path = vim.bo.path
	local module_file = vim.fn.findfile(resolved .. ".py", path)
	if module_file ~= "" then
		return module_file
	end

	local package_init = vim.fn.findfile(resolved .. "/__init__.py", path)
	if package_init ~= "" then
		return package_init
	end

	return resolved
end

_G.PythonGfIncludeExpr = python_gf_includeexpr

-- Make `gf` work in Python projects that use a `src/` layout.
vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		local current_file = vim.api.nvim_buf_get_name(0)
		local start_dir = current_file ~= "" and vim.fs.dirname(current_file) or vim.fn.getcwd()
		local root_markers = vim.fs.find({ "pyproject.toml", "setup.py", "setup.cfg", ".git" }, {
			path = start_dir,
			upward = true,
		})
		local root = root_markers[1] and vim.fs.dirname(root_markers[1]) or nil

		if root then
			local src_dir = root .. "/src"
			if vim.fn.isdirectory(src_dir) == 1 then
				vim.opt_local.path:append(src_dir)
			end
		end

		vim.opt_local.suffixesadd:append({ ".py", "/__init__.py" })
		vim.opt_local.includeexpr = "v:lua.PythonGfIncludeExpr(v:fname)"
	end,
})
