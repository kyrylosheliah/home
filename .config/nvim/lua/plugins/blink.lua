-- `vim.o.pumheight` -- Maximum number of items to show in the popup menu

-- stores opts for the latest config() function call
local opts_save = {};

local enabled_auto_show_opts = {
  cmdline = {
    completion = {
      menu = {
        auto_show = true,
      },
    }
  },
  completion = {
    menu = {
      auto_show = true,
    },
    documentation = { auto_show = true }, --, auto_show_delay_ms = 500 },
    trigger = {
      prefetch_on_insert = true,
      show_in_snippet = true,
      show_on_backspace = true,
      show_on_backspace_in_keyword = true,
      show_on_backspace_after_accept = true,
      show_on_backspace_after_insert_enter = true,
      show_on_keyword = true,
      show_on_trigger_character = true,
      show_on_insert = true,
    },
  },
  signature = {
    enabled = true,
    trigger = {
      show_on_keyword = true,
      show_on_trigger_character = true,
      show_on_insert = true,
      show_on_insert_on_trigger_character = true,
      show_on_accept = true,
      show_on_accept_on_trigger_character = true,
    },
    window = {
      show_documentation = true,
    },
  },
}

local disabled_auto_show_opts = {
  cmdline = {
    completion = {
      menu = {
        auto_show = false,
      },
    }
  },
  completion = {
    menu = {
      auto_show = false,
    },
    documentation = { auto_show = false }, --, auto_show_delay_ms = 500 },
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
  signature = {
    enabled = false,
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
}

local function mix_in_opts()
  local auto_show_opts = {}
  local lsp = require("base.lsp")
  if lsp.show_automatically == true then
    auto_show_opts = enabled_auto_show_opts
  else
    auto_show_opts = disabled_auto_show_opts
  end
  local dynamic_opts = vim.tbl_deep_extend('force', opts_save, auto_show_opts)
  return dynamic_opts
end

local function reload(opts)
  for name,_ in pairs(package.loaded) do
    if name:match("^blink") then
      package.loaded[name] = nil
    end
  end
  --dofile(vim.fn.stdpath("config") .. "/lua/plugins/blink.lua")
  require("blink.cmp").setup(opts)
end

return {
  'saghen/blink.cmp',
  event = 'VimEnter',
  version = '1.*',
  opts = {
    keymap = {
      preset = 'none',
      ['<C-e>'] = {
        "hide",
        -- function(cmp)
        --   cmp.hide()
        --   cmp.hide_signature()
        -- end,
      },
      ['<C-y>'] = { "select_and_accept" },
      ['<C-n>'] = { "show", "select_next" },
      ['<C-p>'] = { "show", "select_prev" },
      ['<C-d>'] = { "show_documentation", "scroll_documentation_down" },
      ['<C-u>'] = { "show_documentation", "scroll_documentation_up" },
      --['<C-s>'] = { "show_signature" },
      --['<C-S-J>'] = { "show_signature", "scroll_signature_down" },
      --['<C-S-K>'] = { "show_signature", "scroll_signature_up" },
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
      keyword = {
        range = "full",
      },
      list = {
        selection = {
          preselect = true,
          auto_insert = false,
        },
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
  },
  config = function(_, opts)
    opts_save = opts

    require("blink.cmp").setup(mix_in_opts())

    require("base.command").add_menu_commands("lsp", {
      { name = "toggle completion automatic show/pop-up", cmd = function()
        local lsp = require("base.lsp")
        lsp.show_automatically = not lsp.show_automatically
        local dynamic_opts = mix_in_opts()
        reload(dynamic_opts)
      end },
    })
  end,
}
