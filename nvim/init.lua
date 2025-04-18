require("plugins")

-- disable netrw at the very start of your init.lua (Nvim tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.wo.number = true
vim.g.mapleader = " "
vim.opt.tabstop = 2       -- Number of spaces that a <Tab> in the file counts for
vim.opt.shiftwidth = 2    -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true  -- Use spaces instead of tabs
vim.opt.smartindent = true -- Make indenting smarter again
vim.opt.autoindent = true -- Auto indent
vim.opt.syntax = "on"     -- Enable syntax highlighting
vim.opt.termguicolors = true -- Enable 24-bit RGB color in the terminal
vim.opt.showmode = false   -- Don't show mode in command line
vim.cmd 'colorscheme tokyonight-night' -- Add theme
vim.opt.laststatus = 3 -- Avante setting

-- Terminal
vim.api.nvim_set_keymap('t', '<Esc><Esc>', [[<C-\><C-n>]], {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>t', ':terminal<CR>', {noremap = true, silent = true})

-- Statusline
require("feline").setup()

-- Tree navigator
require("nvim-tree").setup({
  git = {
    ignore = false,  -- <- this is the key part
  },
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeOpen<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tn', ':tabnew<CR>', { noremap = true, silent = true })

-- For quarto
require('otter')

-- Quarto
require('quarto').setup{
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
    never_run = { 'yaml' }, -- filetypes which are never sent to a code runner
  },
}

local runner = require("quarto.runner")
vim.keymap.set("n", "<localleader>qc", runner.run_cell,  { desc = "run cell", silent = true })
vim.keymap.set("n", "<localleader>qa", runner.run_above, { desc = "run cell and above", silent = true })
vim.keymap.set("n", "<localleader>qA", runner.run_all,   { desc = "run all cells", silent = true })
vim.keymap.set("n", "<localleader>ql", runner.run_line,  { desc = "run line", silent = true })
vim.keymap.set("v", "<localleader>q",  runner.run_range, { desc = "run visual range", silent = true })
vim.keymap.set("n", "<localleader>RA", function()
  runner.run_all(true)
end, { desc = "run all cells of all languages", silent = true })

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
    completion = {
      -- Set to false to disable completion.
      nvim_cmp = true,
      -- Trigger completion at 2 chars.
      min_chars = 2,
    },
    daily_notes = {
      folder = "Root/Daily note"
    },
    new_notes_location = "Zettlekasten",
    -- Optional, alternatively you can customize the frontmatter data.
    ---@return table
    note_frontmatter_func = function(note)
      -- Add the title of the note as an alias.
      if note.title then
        note:add_alias(note.title)
      end

      local out = {aliases = note.aliases, tags = note.tags }

      -- `note.metadata` contains any manually added fields in the frontmatter.
      -- So here we just make sure those fields are kept in the frontmatter.
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end

      return out
    end,
  })
  vim.opt.conceallevel = 1
  vim.keymap.set('n', '<Leader>og', ':ObsidianSearch<CR>', { desc = 'Obsidian Search' })
  vim.keymap.set('n', '<Leader>os', ':ObsidianQuickSwitch<CR>', { desc = 'Obsidian Quick Switch' })
  vim.keymap.set('n', '<Leader>od', ':ObsidianToday<CR>', { desc = 'Obsidian Today' })
  vim.keymap.set('n', '<Leader>ofl', ':ObsidianFollowLink<CR>', { desc = 'Obsidian Follow Link' })
end

--------------------------------------------------------------
--- Codeium stuff
vim.keymap.set('i', '<C-g>', function () return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
------------------------------------------------------------

require("telescope").setup()
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

require("render-markdown").setup({
  file_types = {'markdown', 'quarto'}
})



-- Iron REPL
local iron = require("iron.core")
local view = require("iron.view")
local common = require("iron.fts.common")

iron.setup {
  config = {
    -- Whether a repl should be discarded or not
    scratch_repl = true,
    -- Your repl definitions come here
    repl_definition = {
      sh = {
        -- Can be a table or a function that
        -- returns a table (see below)
        command = {"bash"}
      },
      python = {
        command = { "python3" },  -- or { "ipython", "--no-autoindent" }
        format = common.bracketed_paste_python,
        block_deviders = { "# %%", "#%%" },
      }
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
    -- See below for more information
    repl_open_cmd = "vertical botright 80 split"

    -- repl_open_cmd can also be an array-style table so that multiple 
    -- repl_open_commands can be given.
    -- When repl_open_cmd is given as a table, the first command given will
    -- be the command that `IronRepl` initially toggles.
    -- Moreover, when repl_open_cmd is a table, each key will automatically
    -- be available as a keymap (see `keymaps` below) with the names 
    -- toggle_repl_with_cmd_1, ..., toggle_repl_with_cmd_k
    -- For example,
    -- 
    -- repl_open_cmd = {
    --   view.split.vertical.rightbelow("%40"), -- cmd_1: open a repl to the right
    --   view.split.rightbelow("%25")  -- cmd_2: open a repl below
    -- }

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
    italic = true
  },
  ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
}

vim.keymap.set('n', '<leader>rf', '<cmd>IronFocus<cr>')
vim.keymap.set('n', '<leader>rh', '<cmd>IronHide<cr>')
---------------------------------------------

-- Dashboard
require('dashboard').setup{
  theme='hyper',
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
      icon = '  ',
      action = 'Telescope find_files path='
    },
    mru = {
      enable = true,
  }
  }
}
---------------------------------------------

-- Command completion
local cmp = require('cmp')
local luasnip = require('luasnip')
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
-- Prevents autocomplete from showing up normal text suggestions, this way everything else works
--    { name = 'buffer' },
    { name = 'path' },
  }),
})
---------------------------------------------

-- LSP Configuration
local lspconfig = require('lspconfig')
lspconfig.pyright.setup{
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
}

lspconfig.ruff.setup({
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

lspconfig.ts_ls.setup{
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
}

lspconfig.r_language_server.setup {
  capabilities = require('cmp_nvim_lsp').default_capabilities(), 
}

vim.keymap.set('n', '<leader>d]', vim.diagnostic.open_float, {desc = "Show diagnostic under cursor"})
---------------------------------------------

-- DAP
local dap = require('dap')
dap.adapters.python = function(cb, config)
  if config.request == 'attach' then
    ---@diagnostic disable-next-line: undefined-field
    local port = (config.connect or config).port
    ---@diagnostic disable-next-line: undefined-field
    local host = (config.connect or config).host or '127.0.0.1'
    cb({
      type = 'server',
      port = assert(port, '`connect.port` is required for a python `attach` configuration'),
      host = host,
      options = {
        source_filetype = 'python',
      },
    })
  else
    cb({
      type = 'executable',
      command = 'path/to/virtualenvs/debugpy/bin/python',
      args = { '-m', 'debugpy.adapter' },
      options = {
        source_filetype = 'python',
      },
    })
  end
end
----------------------------------------------

-- TREE SITTER CONFIG
require("nvim-treesitter.configs").setup{
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "r" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  ignore_install = { "javascript" },

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
}
---------------------------------------------
