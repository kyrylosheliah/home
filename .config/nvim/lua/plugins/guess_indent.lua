return {
  'NMAC427/guess-indent.nvim',
  opts = {},
  config = function(_, opts)
    require('guess-indent').setup(opts)
    require("base.command").add_commands({
      { name = "guess indent", cmd = function()
        local lsp = require("base.lsp")
        vim.cmd("GuessIndent")
        local use_spaces = vim.opt_local.expandtab:get()
        if use_spaces then
          local space_count = vim.opt_local.shiftwidth:get()
          lsp.apply_indent({ use_tabs = false, space_count = space_count })
        else
          local space_count = vim.opt_local.tabstop:get()
          lsp.apply_indent({ use_tabs = false, space_count = space_count })
        end
      end, },
    })
  end,
}
