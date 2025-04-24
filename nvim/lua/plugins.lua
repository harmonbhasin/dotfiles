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
		"vhyrro/luarocks.nvim",
		priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
		config = true,
	},
	"sindrets/diffview.nvim",
	"nvim-tree/nvim-web-devicons",
	"glepnir/dashboard-nvim",
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"sharkdp/fd",
		},
	},
	"nvim-lua/plenary.nvim",
	-- status line
	{
		"famiu/feline.nvim",
		config = function()
			vim.opt.termguicolors = true -- Enable 24-bit RGB color in the terminal
			require("feline").setup()
		end,
	},
	"kyazdani42/nvim-tree.lua",
	"nvim-treesitter/nvim-treesitter",
	"nvim-lua/lsp-status.nvim",
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
	-- Code assistant
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("config.codecompanion")
		end,
	},
	-- Theme
	{
		"tiagovla/tokyodark.nvim",
		opts = {
			-- custom options here
		},
		config = function(_, opts)
			require("tokyodark").setup(opts) -- calling setup is optional
			vim.cmd([[colorscheme tokyodark]])
		end,
	},
	"stevearc/dressing.nvim",
	"MunifTanjim/nui.nvim",
	-- Render markdown
	{
		"MeanderingProgrammer/render-markdown.nvim",
		config = function()
			require("render-markdown").setup({
				file_types = { "markdown" },
			})
		end,
	},
	"hrsh7th/nvim-cmp",
	"Exafunction/codeium.vim",
	"neovim/nvim-lspconfig",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"L3MON4D3/LuaSnip",
	"saadparwaiz1/cmp_luasnip",
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
	"Vigemus/iron.nvim",
	"epwalsh/obsidian.nvim",
	"R-nvim/R.nvim",
	"LukeGoodsell/nextflow-vim",
	"quarto-dev/quarto-nvim",
	-- For quarto
	{
		"jmbuhr/otter.nvim",
		config = function()
			require("otter").setup()
		end,
	},
	"tpope/vim-fugitive",
	"pwntester/octo.nvim",
	"folke/which-key.nvim",
	"folke/flash.nvim",
}

--  'folke/tokyonight.nvim',
-- {
--  "yetone/avante.nvim",
--  event = "VeryLazy",
--  version = false,
--  config = function()
--    require("config.avante")
--  end,
--  dependencies = {
--    "nvim-treesitter/nvim-treesitter",
--    "stevearc/dressing.nvim",
--    "nvim-lua/plenary.nvim",
--    "MunifTanjim/nui.nvim",
--  },
--},
--
--

require("lazy").setup(plugins)
