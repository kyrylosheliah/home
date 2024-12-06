return {

  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      --"hrsh7th/cmp-nvim-lsp-signature-help",
      --'hrsh7th/cmp-calc',
      --'hrsh7th/cmp-emoji',
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
      --local cmdline_mapping_preset = cmp.mapping.preset.cmdline()
      local mapping = { -- cmp.mapping.preset.insert(
        --['<C-Space>'] = cmp.mapping.complete(), -- only in gui
        ['<C-n>'] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_next_item(cmp_select)
          else
            cmp.complete()
          end
        end, { "i", "c" }),
        ['<C-p>'] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_prev_item(cmp_select)
          else
            cmp.complete()
          end
        end, { "i", "c" }),
        ['<C-d>'] = cmp.mapping(function()
          if cmp.visible_docs() then
            cmp.scroll_docs(1)
          else
            cmp.open_docs()
          end
        end, { "i", "c" }),
        ['<C-u>'] = cmp.mapping(function()
          if cmp.visible_docs() then
            cmp.scroll_docs(-1)
          else
            cmp.open_docs()
          end
        end, { "i", "c" }),
        ['<C-y>'] = cmp.mapping(cmp.mapping.confirm({ select = true }), { "i", "c" }),
        ['<Esc>'] = cmp.mapping(function()
          if cmp.visible() then
            cmp.close()
          else -- restore keypress
            local key = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
            vim.api.nvim_feedkeys(key, 'n', false)
          end
        end, { "i", "c" }),
        --[[['<CR>'] = cmp.mapping(function()
          if cmp.visible() then
            cmp.confirm({ select = true })
          else -- restore keypress
            local key = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
            vim.api.nvim_feedkeys(key, 'n', false)
          end
        end, { "i", "c" }),]]
      }
      local more_opts = {
        experimental = {
          ghost_text = { hl_group = "NonText" },
        },
        completion = {
          autocomplete = false,
          --completeopt = vim.o.completeopt,
          --keyword_length = 1,
        },
        view = {
          docs = {
            auto_open = false,
          },
        },
        --[[window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },]]
        mapping = mapping,
        cmp.setup.cmdline({ "/", "?" }, {
          mapping = mapping,
          sources = {
            { name = "buffer", max_item_count = 5 },
          },
        }),
        cmp.setup.cmdline(":", {
          mapping = mapping,
          sources = cmp.config.sources({
            { name = "path", max_item_count = 5 },
            { name = "cmdline", option = { ignore_cmds = { "Man", "!" } }, max_item_count = 5 },
          }),
        }),
        sources = {
          --{ name = 'nvim_lsp_signature_help', max_item_count = 5 },
          { name = 'nvim_lsp', max_item_count = 5 },
          { name = "buffer", max_item_count = 5 },
          { name = "path", max_item_count = 5 },
          --{ name = "calc", max_item_count = 5 },
          --{ name = "emoji", max_item_count = 5 },
          --{ name = 'codeium', max_item_count = 5 },
        },
      }
      opts = vim.tbl_deep_extend('force', opts, more_opts)
      cmp.setup(opts)
    end,
  },

}
