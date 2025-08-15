return {
  'folke/trouble.nvim',
  opts = {
    --icons = false,
    focus = true,
    modes = {
      lsp = {
        win = { position = "right" },
      },
    },
  },
  config = function(_, opts)
    local trouble = require('trouble')
    trouble.setup(opts)
    vim.g.add_commands({
      { name = "toggle trouble workspace diagnostics", cmd = trouble.toggle, },
      { name = "toggle trouble document diagnostics", cmd = function() trouble.toggle({ filter = { buf = 0 } }) end, },
      { name = "toggle trouble quickfix", cmd = function() trouble.toggle('quickfix') end, },
      { name = "toggle trouble loclist", cmd = function() trouble.toggle('loclist') end, },
      { name = "toggle trouble todo", cmd = function() trouble.toggle('todo') end, },
      { name = "next trouble", cmd = function() trouble.next({skip_groups = true, jump = true}) end, },
      { name = "previous trouble", cmd = function() trouble.previous({skip_groups = true, jump = true}) end, },
    })
  end,
}
