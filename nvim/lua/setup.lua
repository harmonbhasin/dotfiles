-- ABOUTME: Plugin setup and configuration calls
-- ABOUTME: Contains all plugin .setup() calls and plugin-specific configurations

-- Set colorscheme after plugins are loaded
vim.cmd("colorscheme ashen")

require("autoclose").setup()

require("colorizer").setup()
-- Oil
require("diffview").setup()

-- Surround
require("mini.surround").setup({
	mappings = {
		add = "gsa", -- Add surrounding in Normal and Visual modes
		delete = "gsd", -- Delete surrounding
		find = "gsf", -- Find surrounding (to the right)
		find_left = "gsF", -- Find surrounding (to the left)
		highlight = "gsh", -- Highlight surrounding
		replace = "gsr", -- Replace surrounding
		update_n_lines = "gsn", -- Update `n_lines`

		suffix_last = "l", -- Suffix to search with "prev" method
		suffix_next = "n", -- Suffix to search with "next" method
	},
})

-- Harpoon
local harpoon = require("harpoon")
harpoon:setup()

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

-- Get the home directory path and construct the full path to check
local home = os.getenv("HOME")
local obsidian_path = home .. "/personal/obsidian/main"

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
		notes_subdir = "Knowledge",

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
end

local nextflow_ls_path = "/home/ec2-user/language-server/build/libs"

-- Nextflow LSP
if path_exists(nextflow_ls_path) then
	-- This function runs when the LSP attaches to a buffer
	local on_attach = function(client, bufnr)
		-- This line tells Neovim the server cannot format, so it won't try
		client.server_capabilities.documentFormattingProvider = false
	end

	vim.lsp.config("nextflow_ls", {
		cmd = { "java", "-jar", nextflow_ls_path .. "/language-server-all.jar" },
		filetypes = { "nextflow" },
		on_attach = on_attach,
		settings = {
			nextflow = {
				files = {
					exclude = { ".git", ".nf-test", "work" },
				},
			},
		},
	})
end

vim.lsp.enable("nextflow_ls")

-- Telescope
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")

local telescopeConfig = require("telescope.config")

-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

-- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")
-- I don't want to search in the `.git` directory.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

require("telescope").setup({
	defaults = {
		vimgrep_arguments = vimgrep_arguments,
		--layout_strategy = "vertical",
		--layout_config = { height = 0.5 },
		mappings = {
			i = {
				["<c-d>"] = actions.delete_buffer,
			},
			n = {
				["dd"] = actions.delete_buffer,
			},
		},
	},
	pickers = {
		find_files = {
			-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
			find_command = {
				"rg",
				"--files",
				"--hidden",
				"--no-ignore",
				"--glob",
				"!**/.git/*",
				"--glob",
				"!**/.mypy/*",
				"--glob",
				"!**/.venv/*",
				"--glob",
				"!**/.pytest_cache/*",
				"--glob",
				"!**/__pycache__/*",
				"--glob",
				"!**/*.egg-info/*",
				"--glob",
				"!**/.ruff_cache/*",
				"--glob",
				"!**/.mypy_cache/*",
				"--glob",
				"!**/node_modules/*",
			},
		},
	},
})

-- Iron REPL
local iron = require("iron.core")
local view = require("iron.view")
local common = require("iron.fts.common")

iron.setup({
	config = {
		-- Whether a repl should be discarded or not
		scratch_repl = true,
		-- Preferred REPL for filetypes
		preferred = {
			r = "r",
			rmd = "r",
			qmd = "r",
		},
		-- Your repl definitions come here
		repl_definition = {
			bash = {
				-- Can be a table or a function that
				-- returns a table (see below)
				command = { "sh" },
			},
			zsh = {
				-- Can be a table or a function that
				-- returns a table (see below)
				command = { "zsh" },
			},
			python = {
				command = { "python3" }, -- or { "ipython", "--no-autoindent" }
				format = common.bracketed_paste_python,
				block_deviders = { "# %%", "#%%" },
			},
			r = {
				command = { "R" },
			},
			rmd = {
				command = { "R" },
			},
			quarto = {
				command = { "R" },
			},
			groovy = {
				command = { "groovysh" },
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

-- Mason
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

mason.setup()
local ensure_installed = { "basedpyright" }
if os.getenv("HOME") ~= "/home/ec2-user" then
	table.insert(ensure_installed, "ruff")
end

mason_lspconfig.setup({
	ensure_installed = ensure_installed,
})

-- LSP Configuration
local lspconfig = require("lspconfig")

lspconfig.ts_ls.setup({
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

lspconfig.r_language_server.setup({
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

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
	markdown = {
		enable = true,
		-- configuration here or nothing for defaults
	},

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	auto_install = true,

	---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
	-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

	highligh = {
		enable = true,
	},
})
