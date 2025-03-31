local lspconfig = require('lspconfig')
local cmp = require('cmp')
local luasnip = require('luasnip')

-- Set up nvim-cmp
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
    { name = 'buffer' },
    { name = 'path' },
  }),
})

-- Set up language servers
-- You need to install language servers separately
-- For example, for Python: pip install python-language-server
-- For JavaScript/TypeScript: npm install -g typescript typescript-language-server

-- Python
lspconfig.pyright.setup{
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
}

-- TypeScript/JavaScript
lspconfig.ts_ls.setup{
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
}

-- Add more language servers as needed
