return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    --'hrsh7th/cmp-calc',
    'hrsh7th/cmp-emoji',
    {
      enabled = false,
      "Exafunction/codeium.vim",
      event = "BufEnter",
      dependencies = { "nvim-lua/plenary.nvim" },
    },
  },
  config = function(_, opts)
    local cmp = require('cmp')
    local cmp_select = { behavior = cmp.SelectBehavior.Select }
    local cmdline_mapping_preset = cmp.mapping.preset.cmdline()
    local more_opts = {
      --experimental = {
      --  ghost_text = { hl_group = "NonText" },
      --},
      completion = {
        keyword_length = 1,
        completeopt = vim.o.completeopt,
        --autocomplete = false,
      },
      --preselect = cmp.PreselectMode.None,
      view = {
        docs = {
          auto_open = false,
        },
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = { -- cmp.mapping.preset.insert(
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<Esc>'] = cmp.mapping.close(),
        ['<C-y>'] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        }),
      },
      cmp.setup.cmdline({ "/", "?" }, {
        completion = { completeopt = vim.o.completeopt },
        mapping = cmdline_mapping_preset,
        sources = {
          { name = "buffer", max_item_count = 5 },
        },
      }),
      cmp.setup.cmdline(":", {
        completion = { completeopt = vim.o.completeopt },
        mapping = cmdline_mapping_preset,
        sources = cmp.config.sources({
          { name = "path", max_item_count = 5 },
          { name = "cmdline", option = { ignore_cmds = { "Man", "!" } }, max_item_count = 5 },
        }),
      }),
      sources = {
        { name = 'nvim_lsp', max_item_count = 5 },
        { name = 'nvim_lsp_signature_help', max_item_count = 5 },
        { name = "buffer", max_item_count = 5 },
        { name = "path", max_item_count = 5 },
        --{ name = "calc", max_item_count = 5 },
        { name = "emoji", max_item_count = 5 },
        --{ name = 'codeium' },
      },
    }
    opts = vim.tbl_deep_extend('force', opts, more_opts)
    cmp.setup(opts)
  end,
}
