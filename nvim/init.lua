require("plugins")

vim.g.python_recommended_style = 0
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
vim.opt.ignorecase = true -- Ignore case

vim.opt.showtabline = 0 --remove tabline

--
require("diffview").setup()
vim.api.nvim_set_keymap("n", "<leader>gdd", ":DiffviewOpen<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>gdf", ":DiffviewFileHistory %<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>gdq", ":DiffviewClose<CR>", { noremap = true, silent = true })

-- Surround
require("mini.surround").setup({
	mappings = {
		add = "gsa", -- Add surrounding in Normal and Visual modes
		delete = "gsd", -- Delete surrounding
		find = "gsf", -- Find surrounding (to the right)
		find_left = "gsF", -- Find surrounding (to the left)
		highlight = "gh", -- Highlight surrounding
		replace = "gsr", -- Replace surrounding
		update_n_lines = "gsn", -- Update `n_lines`

		suffix_last = "l", -- Suffix to search with "prev" method
		suffix_next = "n", -- Suffix to search with "next" method
	},
})

-- Notion
vim.keymap.set("n", "<leader>nm", function()
	require("notion").openMenu()
end)

require("notion").setup({
	autoUpdate = true, --Allow the plugin to automatically update the data from the Notion API
	open = "notion", --If not set, or set to something different to notion, will open in web browser
	keys = { --Menu keys
		deleteKey = "d",
		editKey = "e",
		openNotion = "o",
		itemAdd = "a",
		viewKey = "v",
	},
	delays = { --Delays before running specific actions
		reminder = 4000,
		format = 200,
		update = 10000,
	},
	notifications = true, --Enable notifications
	editor = "medium", --light/medium/full, changes the amount of data displayed in editor
	viewOnEdit = {
		enabled = true, --Enable double window, view and edit simultaneously
		replace = false, --Replace current window with preview window
	},
	direction = "vsplit", --Direction windows will be opened in
	noEvent = "No events",
	debug = true, --Enable some error messages on failed API calls
})
require("notion").update({
	silent = false,
	window = nil,
})

-- Harpoon
local harpoon = require("harpoon")

harpoon:setup()
vim.keymap.set("n", "<leader>m", function()
	harpoon:list():add()
end)
vim.keymap.set("n", "<leader>e", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end)

vim.keymap.set("n", "<leader>h", function()
	harpoon:list():select(1)
end)
vim.keymap.set("n", "<leader>j", function()
	harpoon:list():select(2)
end)
vim.keymap.set("n", "<leader>k", function()
	harpoon:list():select(3)
end)
vim.keymap.set("n", "<leader>l", function()
	harpoon:list():select(4)
end)

-- Buffer list
vim.keymap.set("n", "<C-P>", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<C-N>", ":bnext<CR>", { desc = "Next buffer" })

-- Toggle previous & next buffers stored within Harpoon list
--vim.keymap.set("n", "<C-S-P>", function()
--	harpoon:list():prev()
--end)
--vim.keymap.set("n", "<C-S-N>", function()
--	harpoon:list():next()
--end)

-- Make Fugitive use Git's configured pager (Delta)
vim.g.fugitive_use_git_pager = 1

-- Quicker
vim.keymap.set("n", "<leader>q", function()
	require("quicker").toggle()
end, {
	desc = "Toggle quickfix",
})
vim.keymap.set("n", "<leader>w", function()
	require("quicker").toggle({ loclist = true })
end, {
	desc = "Toggle loclist",
})

-- Go between quickfixs

-- CodeCompanion
vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Toggle Code Companion Chat" })
vim.keymap.set({ "n", "v" }, "<leader>an", "<cmd>CodeCompanionChat<cr>", { desc = "Open New Code Companion Chat" })
vim.keymap.set({ "n", "v" }, "<leader>at", "<cmd>CodeCompanionActions<cr>", { desc = "Open Code Companion Actions" })

-- Terminal
vim.api.nvim_set_keymap("t", "<Esc><Esc>", [[<C-\><C-n>]], { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>t", ":terminal<CR>", { noremap = true, silent = true })

-- New tab
vim.api.nvim_set_keymap("n", "<leader>tn", ":tabnew<CR>", { noremap = true, silent = true })

-- Quarto
require("quarto").setup({
	debug = false,
	closePreviewOnExit = true,
	lspFeatures = {
		enabled = true,
		chunks = "curly",
		languages = { "r", "python", "julia", "bash", "html" },
		diagnostics = {
			enabled = true,
			triggers = { "BufWritePost" },
		},
		completion = {
			enabled = true,
		},
	},
	codeRunner = {
		enabled = true,
		default_method = "iron", -- "molten", "slime", "iron" or <function>
		ft_runners = {}, -- filetype to runner, ie. `{ python = "molten" }`.
		-- Takes precedence over `default_method`
		never_run = { "yaml" }, -- filetypes which are never sent to a code runner
	},
})

-- Get the home directory path and construct the full path to check
local home = os.getenv("HOME")
local obsidian_path = home .. "/personal/obsidian/main"

-- Function to check if path exists
local function path_exists(path)
	local file = io.open(path, "r")
	if file then
		file:close()
		return true
	else
		return false
	end
end

-- Obsidian
if path_exists(obsidian_path) then
	require("obsidian").setup({
		workspaces = {
			{
				name = "personal",
				path = "~/personal/obsidian/main",
			},
		},
		-- Optional, if you keep notes in a specific subdirectory of your vault.
		notes_subdir = "Zettlekasten",

		completion = {
			-- Set to false to disable completion.
			nvim_cmp = true,
			-- Trigger completion at 2 chars.
			min_chars = 2,
		},
		daily_notes = {
			folder = "Root/Daily note",
		},
		new_notes_location = "current_dir",
		-- Optional, customize how note IDs are generated given an optional title.
		---@param title string|?
		---@return string
		note_id_func = function(title)
			return title
		end,
		-- Optional, alternatively you can customize the frontmatter data.
		---@return table
		note_frontmatter_func = function(note)
			-- Add the title of the note as an alias.
			if note.title then
				note:add_alias(note.title)
			end

			local out = { aliases = note.aliases, tags = note.tags }

			-- `note.metadata` contains any manually added fields in the frontmatter.
			-- So here we just make sure those fields are kept in the frontmatter.
			if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
				for k, v in pairs(note.metadata) do
					out[k] = v
				end
			end

			return out
		end,
		-- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
		-- URL it will be ignored but you can customize this behavior here.
		---@param url string
		follow_url_func = function(url)
			-- Open the URL in the default web browser.
			vim.fn.jobstart({ "open", url }) -- Mac OS
			-- vim.fn.jobstart({"xdg-open", url})  -- linux
			-- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
			-- vim.ui.open(url) -- need Neovim 0.10.0+
		end,
		templates = {
			folder = "Templates",
			date_format = "%Y-%m-%d-%a",
			time_format = "%H:%M",
		},
	})
	vim.opt.conceallevel = 1
	vim.keymap.set("n", "<Leader>n/", ":ObsidianSearch<CR>", { desc = "Obsidian Search" })
	vim.keymap.set("n", "<Leader>nff", ":ObsidianQuickSwitch<CR>", { desc = "Obsidian Quick Switch" })
	vim.keymap.set("n", "<Leader>nd", ":ObsidianToday<CR>", { desc = "Obsidian Today" })
	vim.keymap.set("n", "<Leader>nfl", ":ObsidianFollowLink<CR>", { desc = "Obsidian Follow Link" })
	vim.keymap.set("n", "<Leader>nt", ":ObsidianTOC<CR>", { desc = "Show note table of contents" })
	vim.keymap.set("n", "<leader>nc", function()
		-- Prompt the user for the note title
		local title = vim.fn.input("Enter note title: ")

		-- Check if the user entered a title (didn't press Cancel or leave empty)
		if title and title ~= "" then
			-- Execute the ObsidianNewFromTemplate command with the provided title
			vim.cmd("ObsidianNewFromTemplate " .. title)
		else
			-- Optionally, provide feedback if no title was entered
			print("No title entered, note creation cancelled.")
		end
	end, { desc = "Create new Obsidian note from template with title" })
end

-- Debug keybindings
vim.keymap.set("n", "<leader>db", function()
	require("dap").toggle_breakpoint()
end, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dc", function()
	require("dap").continue()
end, { desc = "Continue Debugging" })
vim.keymap.set("n", "<leader>du", function()
	require("dapui").toggle()
end, { desc = "Toggle Debug UI" })
vim.keymap.set("n", "<leader>ds", function()
	require("dap").step_over()
end, { desc = "Step Over" })
vim.keymap.set("n", "<leader>di", function()
	require("dap").step_into()
end, { desc = "Step Into" })
vim.keymap.set("n", "<leader>do", function()
	require("dap").step_out()
end, { desc = "Step Out" })
vim.keymap.set("n", "<leader>dt", function()
	require("dap").terminate()
end, { desc = "Terminate Debug" })

--------------------------------------------------------------
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
	pattern = { "*.md", "*.txt", ".git-credentials", ".env", ".env.*" },
	command = "CodeiumDisable",
})
vim.keymap.set("i", "<C-g>", function()
	return vim.fn["codeium#Accept"]()
end, { expr = true, silent = true })
vim.keymap.set("i", "<c-;>", function()
	return vim.fn["codeium#CycleCompletions"](1)
end, { expr = true, silent = true })
vim.keymap.set("i", "<c-,>", function()
	return vim.fn["codeium#CycleCompletions"](-1)
end, { expr = true, silent = true })
vim.keymap.set("i", "<c-x>", function()
	return vim.fn["codeium#Clear"]()
end, { expr = true, silent = true })
------------------------------------------------------------

local builtin = require("telescope.builtin")
local actions = require("telescope.actions")

require("telescope").setup({
	defaults = {
		layout_strategy = "vertical",
		layout_config = { height = 0.5 },

		mappings = {
			i = {
				["<c-d>"] = actions.delete_buffer,
			},
			n = {
				["dd"] = actions.delete_buffer,
			},
		},
	},
})
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>/", builtin.live_grep, {})
vim.keymap.set("n", "<leader>o", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

-- Iron REPL
local iron = require("iron.core")
local view = require("iron.view")
local common = require("iron.fts.common")

iron.setup({
	config = {
		-- Whether a repl should be discarded or not
		scratch_repl = true,
		-- Your repl definitions come here
		repl_definition = {
			sh = {
				-- Can be a table or a function that
				-- returns a table (see below)
				command = { "bash" },
			},
			python = {
				command = { "python3" }, -- or { "ipython", "--no-autoindent" }
				format = common.bracketed_paste_python,
				block_deviders = { "# %%", "#%%" },
			},
		},
		-- set the file type of the newly created repl to ft
		-- bufnr is the buffer id of the REPL and ft is the filetype of the
		-- language being used for the REPL.
		repl_filetype = function(bufnr, ft)
			return ft
			-- or return a string name such as the following
			-- return "iron"
		end,
		-- How the repl window will be displayed
		repl_open_cmd = "vertical botright 80 split",
	},
	-- Iron doesn't set keymaps by default anymore.
	-- You can set them here or manually add keymaps to the functions in iron.core
	keymaps = {
		toggle_repl = "<leader>rr", -- toggles the repl open and closed.
		-- If repl_open_command is a table as above, then the following keymaps are
		-- available
		-- toggle_repl_with_cmd_1 = "<leader>rv",
		-- toggle_repl_with_cmd_2 = "<leader>rh",
		restart_repl = "<leader>rR", -- calls `IronRestart` to restart the repl
		send_motion = "<leader>sc",
		visual_send = "<leader>sc",
		send_file = "<leader>sf",
		send_line = "<leader>sl",
		send_paragraph = "<leader>sp",
		send_until_cursor = "<leader>su",
		send_mark = "<leader>sm",
		send_code_block = "<leader>sb",
		send_code_block_and_move = "<leader>sn",
		mark_motion = "<leader>mc",
		mark_visual = "<leader>mc",
		remove_mark = "<leader>md",
		cr = "<leader>s<cr>",
		interrupt = "<leader>s<leader>",
		exit = "<leader>sq",
		clear = "<leader>cl",
	},
	-- If the highlight is on, you can change how it looks
	-- For the available options, check nvim_set_hl
	highlight = {
		italic = true,
	},
	ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
})
---------------------------------------------

-- Dashboard
require("dashboard").setup({
	theme = "hyper",
	config = {
		week_header = {
			enable = true,
		},
		packages = {
			enable = true,
		},
		project = {
			enable = true,
			limit = 8,
			icon = "  ",
			action = "Telescope find_files path=",
		},
		mru = {
			enable = true,
		},
	},
})
---------------------------------------------

-- Command completion
local cmp = require("cmp")
local luasnip = require("luasnip")
cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		-- Prevents autocomplete from showing up normal text suggestions, this way everything else works
		--    { name = 'buffer' },
		{ name = "path" },
	}),
})
---------------------------------------------
---
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

mason.setup()
mason_lspconfig.setup()

-- LSP Configuration
local lspconfig = require("lspconfig")
lspconfig.pyright.setup({
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

lspconfig.ruff.setup({
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

lspconfig.ts_ls.setup({
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

lspconfig.r_language_server.setup({
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic under cursor" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Diagnostics to location list" })
---------------------------------------------

----------------------------------------------

-- TREE SITTER CONFIG
require("nvim-treesitter.configs").setup({
	-- A list of parser names, or "all" (the listed parsers MUST always be installed)
	ensure_installed = {
		"c",
		"lua",
		"vim",
		"vimdoc",
		"query",
		"markdown",
		"markdown_inline",
		"r",
		"typescript",
		"javascript",
		"json",
	},

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	auto_install = true,

	---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
	-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

	highlight = {
		enable = true,

		-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
		-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
		-- the name of the parser)
		-- list of language that will be disabled
		disable = { "c", "rust" },
		-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
		disable = function(lang, buf)
			local max_filesize = 100 * 1024 -- 100 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
})
---------------------------------------------
