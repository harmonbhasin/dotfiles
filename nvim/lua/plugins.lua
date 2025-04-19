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
  'sindrets/diffview.nvim',
  'nvim-tree/nvim-web-devicons',
  'glepnir/dashboard-nvim',
  'nvim-telescope/telescope.nvim',
  'nvim-lua/plenary.nvim',
  'famiu/feline.nvim',
  'kyazdani42/nvim-tree.lua',
  'nvim-treesitter/nvim-treesitter',
  'nvim-lua/lsp-status.nvim',
  'BurntSushi/ripgrep',
  'sharkdp/fd',
--  'folke/tokyonight.nvim',
  {
    "tiagovla/tokyodark.nvim",
    opts = {
        -- custom options here
    },
    config = function(_, opts)
        require("tokyodark").setup(opts) -- calling setup is optional
        vim.cmd [[colorscheme tokyodark]]
    end,
   }, 
   {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    config = function()
      require("config.avante")
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
  },
  'stevearc/dressing.nvim',
  'MunifTanjim/nui.nvim',
  'MeanderingProgrammer/render-markdown.nvim',
  'hrsh7th/nvim-cmp',
  'Exafunction/codeium.vim',
  'neovim/nvim-lspconfig',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'L3MON4D3/LuaSnip',
  'saadparwaiz1/cmp_luasnip',
  'mfussenegger/nvim-dap',
  'Vigemus/iron.nvim',
  'epwalsh/obsidian.nvim',
  'R-nvim/R.nvim',
  'LukeGoodsell/nextflow-vim',
  'quarto-dev/quarto-nvim',
  'jmbuhr/otter.nvim',
  'tpope/vim-fugitive',
  'pwntester/octo.nvim',
  'folke/which-key.nvim',
  'folke/flash.nvim'
}

local opts = {}

require("lazy").setup(plugins,opts)
