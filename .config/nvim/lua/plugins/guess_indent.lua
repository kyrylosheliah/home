return {
  'NMAC427/guess-indent.nvim',
  opts = {},
  config = function(_, opts)
    require('guess-indent').setup(opts)
    require("base.command").add_commands({
      { name = "guess indent", cmd = function() vim.cmd("GuessIndent") end, },
    })
  end,
}
