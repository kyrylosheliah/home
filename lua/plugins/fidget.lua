return {
  enabled = false,
  "j-hui/fidget.nvim",
  opts = {
    notification = {
      override_vim_notify = true,
    }
  }
  --[[config = function()
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
  end]],
}
