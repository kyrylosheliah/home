return {
  enabled = true,
  "j-hui/fidget.nvim",
  config = function()
    local fidget = require("fidget")
    fidget.setup()
    vim.notify = fidget.notify
    print = function(...)
      local print_safe_args = {}
      local _ = { ... }
      for i = 1, #_ do
        table.insert(print_safe_args, tostring(_[i]))
      end
      fidget.notify(table.concat(print_safe_args, ' '), "info")
    end
  end,
}
