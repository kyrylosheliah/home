-- `vim.o.pumheight` -- Maximum number of items to show in the popup menu
return {
  'saghen/blink.cmp',
  event = 'VimEnter',
  version = '1.*',
  opts = {
    keymap = {
      preset = 'none',
      ['<C-e>'] = {
        function(cmp)
          cmp.hide()
          cmp.hide_signature()
        end,
      },
      ['<C-y>'] = { "select_and_accept" },
      ['<C-n>'] = { "show", "select_next" },
      ['<C-p>'] = { "show", "select_prev" },
      ['<C-d>'] = { "show_documentation", "scroll_documentation_down" },
      ['<C-M-d>'] = { "show_signature", "scroll_signature_down" },
      ['<C-u>'] = { "show_documentation", "scroll_documentation_up" },
      ['<C-M-u>'] = { "show_signature", "scroll_signature_up" },
    },
    cmdline = {
      enabled = true,
      keymap = { preset = 'inherit' },
      completion = {
        list = {
          selection = {
            preselect = true,
            auto_insert = false,
          },
        },
        menu = {
          auto_show = false,
        },
        ghost_text = {
          enabled = true
        },
      }
    },
    completion = {
      ghost_text = {
        enabled = true,
        show_without_menu = false,
      },
      accept = {
        resolve_timeout_ms = 0,
        auto_brackets = {
          enabled = false,
        },
      },
      -- Optionally, set `auto_show = true` to show the documentation after a delay.
      documentation = { auto_show = false }, --, auto_show_delay_ms = 500 },
      keyword = {
        range = "full",
      },
      list = {
        selection = {
          preselect = true,
          auto_insert = false,
        },
      },
      trigger = {
        prefetch_on_insert = false,
        show_in_snippet = false,
        show_on_backspace = false,
        show_on_backspace_in_keyword = false,
        show_on_backspace_after_accept = false,
        show_on_backspace_after_insert_enter = false,
        show_on_keyword = false,
        show_on_trigger_character = false,
        show_on_insert = false,
      },
    },
    sources = {
      default = {
        'lsp',
        'path',
        'buffer',
      },
    },
    --snippets = { preset = "default"
    -- -- Function to use when expanding LSP provided snippets
    -- expand = function(snippet) vim.snippet.expand(snippet) end,
    -- -- Function to use when checking if a snippet is active
    -- active = function(filter) return vim.snippet.active(filter) end,
    -- -- Function to use when jumping between tab stops in a snippet, where direction can be negative or positive
    -- jump = function(direction) vim.snippet.jump(direction) end,
    --},
    fuzzy = { implementation = 'lua' },
    signature = {
      enabled = true,
      trigger = {
        show_on_keyword = false,
        show_on_trigger_character = false,
        show_on_insert = false,
        show_on_insert_on_trigger_character = false,
        show_on_accept = false,
        show_on_accept_on_trigger_character = false,
      },
      window = {
        show_documentation = false,
      },
    },
  },
}

