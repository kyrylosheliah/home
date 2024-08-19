return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-calc',
    'hrsh7th/cmp-emoji',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    --'rafamadriz/friendly-snippets',
  },
  opts = {
    --experimental = {
    --  ghost_text = { hl_group = "NonText" },
    --},
    completion = { completeopt = "menu,menuone,noinsert" },
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end
    },
    sources = {
      { name = "luasnip" },
      { name = 'nvim_lsp' },
      { name = 'nvim_lsp_signature_help' },
      { name = "path" },
      { name = "buffer" },
      { name = "calc" },
      { name = "emoji" },
    },
  },
  config = function(_, opts)
    local cmp = require('cmp')
    local cmp_select = { behavior = cmp.SelectBehavior.Select }
    --require('luasnip.loaders.from_vscode').lazy_load()
    local variable_opts = {
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        --['<C-f>'] = cmp_action.luasnip_jump_forward(),
        --['<C-b>'] = cmp_action.luasnip_jump_backward(),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<S-Tab>'] = nil,
        ['<S>'] = nil,
      }),
    }
    opts = vim.tbl_deep_extend('force', opts, variable_opts)
    cmp.setup(opts)
  end,
}
