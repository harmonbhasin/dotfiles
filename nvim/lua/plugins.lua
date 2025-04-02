local fn = vim.fn-- Automatically install packer

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
	"git",
	"clone",
	"--depth",
	"1",
	"https://github.com/wbthomason/packer.nvim",
	install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
	augroup packer_user_config
	autocmd!
	autocmd BufWritePost plugins.lua source <afile> | PackerSync
	augroup end
	]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)
  -- Packer can manage itself
	use ("wbthomason/packer.nvim")

  -- Icons
  use ("nvim-tree/nvim-web-devicons")

  -- Syntax highlighting for nextflow
  use ("Mxrcon/nextflow-vim")

  -- dashboard
  use ("glepnir/dashboard-nvim")

  -- Fuzzy search
  use ("nvim-telescope/telescope.nvim")

  -- Statusline
  use ("famiu/feline.nvim")

  -- Navigation
  use ("kyazdani42/nvim-tree.lua")

  -- LSP
  --use ("github/copilot.vim")
  use {
      'nvim-treesitter/nvim-treesitter',
      run = function()
          local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
          ts_update()
      end,
  }  
  use ("nvim-lua/lsp-status.nvim")
  use ("nvim-lua/plenary.nvim")
  use ("BurntSushi/ripgrep")
  use ("sharkdp/fd")

  -- Colors
  use ("folke/tokyonight.nvim")

  -- AI
  use ("stevearc/dressing.nvim")
  use ("MunifTanjim/nui.nvim")
  use ("MeanderingProgrammer/render-markdown.nvim")
  use ("hrsh7th/nvim-cmp")

  use("yetone/avante.nvim")

    -- LSP Configuration
  use 'neovim/nvim-lspconfig'           -- Required for LSP
  use 'hrsh7th/cmp-nvim-lsp'            -- LSP source for nvim-cmp
  use 'hrsh7th/cmp-buffer'              -- Buffer source for nvim-cmp
  use 'hrsh7th/cmp-path'                -- Path source for nvim-cmp
  use 'L3MON4D3/LuaSnip'                -- Snippet engine
  use 'saadparwaiz1/cmp_luasnip'        -- Snippet source for nvim-cmp

  -- Python
  use 'mfussenegger/nvim-dap'
  use {'Vigemus/iron.nvim'}

  -- Obsidian
  use "epwalsh/obsidian.nvim"
    
  -- R
  use ("R-nvim/R.nvim")


	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
