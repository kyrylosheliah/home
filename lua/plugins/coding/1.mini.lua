return {
  { -- Collection of various small independent plugins/modules
    enabled = false,
    'echasnovski/mini.nvim',
    config = function()

      -- Overriding vim.notify with fancy notify if fancy notify exists
      --[[local notify = require("mini.notify")
    notify.setup()
    vim.notify = notify.make_notify({
      ERROR = { duration = 20000 },
      WARN = { duration = 15000 },
      INFO = { duration = 10000 },
    })
    print = function(...)
      local print_safe_args = {}
      local _ = { ... }
      for i = 1, #_ do
        table.insert(print_safe_args, tostring(_[i]))
      end
      notify.notify(table.concat(print_safe_args, ' '), "info")
    end]]

      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup({ n_lines = 500 })

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      --require('mini.align').setup()

    end,
  }
}
