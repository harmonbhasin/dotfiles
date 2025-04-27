-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
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

local plugins = {
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},
		-- Optional dependencies
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
		-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
		config = function()
			require("oil").setup()
		end,
		lazy = false,
	},
	{
		"stevearc/quicker.nvim",
		event = "FileType qf",
		lazy = false,
		---@module "quicker"
		---@type quicker.SetupOptions
		opts = {},
		config = function()
			require("quicker").setup({
				keys = {
					{
						">",
						function()
							require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
						end,
						desc = "Expand quickfix context",
					},
					{
						"<",
						function()
							require("quicker").collapse()
						end,
						desc = "Collapse quickfix context",
					},
				},
			})
		end,
	},
	{
		"vhyrro/luarocks.nvim",
		priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
		config = true,
	},
	-- "sindrets/diffview.nvim",
	"nvim-tree/nvim-web-devicons", -- File icons
	"glepnir/dashboard-nvim", -- Dashboard
	{
		"nvim-telescope/telescope.nvim", -- Fuzzy finder
		dependencies = {
			"sharkdp/fd",
		},
	},
	"nvim-lua/plenary.nvim", -- Common lua functions used by other plugins
	-- status line
	{
		"famiu/feline.nvim",
		config = function()
			vim.opt.termguicolors = true -- Enable 24-bit RGB color in the terminal
			require("feline").setup()
		end,
	},
	-- "kyazdani42/nvim-tree.lua",
	"nvim-treesitter/nvim-treesitter", -- Syntax highlighting
	"nvim-lua/lsp-status.nvim", -- Status bar
	"BurntSushi/ripgrep",
	-- Manage LSP, DAP, Linters, Formatters
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	-- Code formatting
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre", "BufReadPre", "BufNewFile" },
		config = function(_, opts)
			local conform = require("conform")
			conform.setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "ruff" },
					javascript = { "prettier" },
					markdown = { "prettier" },
					svelte = { "prettier" },
					r = { "air" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
					async = false,
				},
			})
			vim.keymap.set({ "n", "v" }, "<leader>mp", function()
				conform.format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 500,
				})
			end, { desc = "Format file or range (in visual mode)" })
		end,
	},
	--https://www.johntobin.ie/blog/debugging_in_neovim_with_nvim-dap/
	{
		"jay-babu/mason-nvim-dap.nvim",
		---@type MasonNvimDapSettings
		opts = {
			-- This line is essential to making automatic installation work
			-- :exploding-brain
			handlers = {},
			automatic_installation = {
				-- These will be configured by separate plugins.
				exclude = {
					"delve",
					"python",
				},
			},
			-- DAP servers: Mason will be invoked to install these if necessary.
			ensure_installed = {
				"bash",
				"codelldb",
				"php",
				"python",
			},
		},
		dependencies = {
			"mfussenegger/nvim-dap",
			"williamboman/mason.nvim",
		},
	},
	{
		"olimorris/codecompanion.nvim", -- Code assistant
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("config.codecompanion")
		end,
	},
	{
		"rebelot/kanagawa.nvim",
		config = function(_, opts)
			vim.cmd([[colorscheme kanagawa-dragon]])
		end,
	},
	-- Render markdown
	{
		"MeanderingProgrammer/render-markdown.nvim",
		config = function()
			require("render-markdown").setup({
				file_types = { "markdown" },
			})
		end,
		lazy = true,
	},
	"hrsh7th/nvim-cmp", -- Completion engine
	"Exafunction/codeium.vim", -- Autocomplete with codeium
	"neovim/nvim-lspconfig", -- LSP
	"hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
	"hrsh7th/cmp-buffer", -- Buffer source for nvim-cmp
	"hrsh7th/cmp-path", -- Path source for nvim-cmp
	"L3MON4D3/LuaSnip",
	"saadparwaiz1/cmp_luasnip",
	-- Debugger
	{
		"mfussenegger/nvim-dap",
		keys = {
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint",
			},

			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Continue",
			},

			{
				"<leader>dC",
				function()
					require("dap").run_to_cursor()
				end,
				desc = "Run to Cursor",
			},

			{
				"<leader>dT",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate",
			},
		},
		dependencies = {
			"mfussenegger/nvim-dap-python",
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
		},
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		config = true,
		dependencies = {
			"mfussenegger/nvim-dap",
		},
	},
	{
		"rcarriga/nvim-dap-ui",
		config = true,
		keys = {
			{
				"<leader>du",
				function()
					require("dapui").toggle({})
				end,
				desc = "Dap UI",
			},
		},
		dependencies = {
			"jay-babu/mason-nvim-dap.nvim",
			"leoluz/nvim-dap-go",
			"mfussenegger/nvim-dap-python",
			"nvim-neotest/nvim-nio",
			"theHamsta/nvim-dap-virtual-text",
		},
	},
	{
		"mfussenegger/nvim-dap-python",
		lazy = true,
		config = function()
			local python = vim.fn.expand("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python")
			require("dap-python").setup(python)
		end,
		-- Consider the mappings at
		-- https://github.com/mfussenegger/nvim-dap-python?tab=readme-ov-file#mappings
		dependencies = {
			"mfussenegger/nvim-dap",
		},
	},
	--
	{
		"Vigemus/iron.nvim", -- REPL
		lazy = true,
	},
	{
		"epwalsh/obsidian.nvim", -- Obsidian
		lazy = true,
	},
	"R-nvim/R.nvim",
	{
		"LukeGoodsell/nextflow-vim", -- Nextlfow
		lazy = true,
	},
	{
		"quarto-dev/quarto-nvim", -- QUARTO
		lazy = true,
	},
	{
		"jmbuhr/otter.nvim", --QUARTO
		config = function()
			require("otter").setup()
		end,
	},
	"tpope/vim-fugitive", -- GIT
	"folke/flash.nvim", -- Move faster
}

require("lazy").setup(plugins)
