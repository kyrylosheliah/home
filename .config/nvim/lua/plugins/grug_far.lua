return {
  "MagicDuck/grug-far.nvim",
  cmd = "GrugFar",
  lazy = false,
  opts = {
    headerMaxWidth = 80,
  },
  config = function(_, opts)
    local grug_far = require('grug-far')
    grug_far.setup(opts)
    require("base.command").add_menu_commands("grug far", {
      { name = "# open", cmd = grug_far.open, },
      { name = "word", cmd = function() grug_far.open({ prefills = { search = vim.fn.expand("<cword>") } }) end, },
      { name = "ast-grep engine", cmd = function() grug_far.open({ engine = 'astgrep' }) end, },
      { name = "transient buffer", cmd = function() grug_far.open({ transient = true }) end, },
      { name = "within current file", cmd = function() grug_far.open({ prefills = { paths = vim.fn.expand("%") } }) end, },
      { name = "selection", cmd = function() grug_far.with_visual_selection({ prefills = { paths = vim.fn.expand("%") } }) end, },
      { name = "within selection", cmd = function() grug_far.open({ visualSelectionUsage = 'operate-within-range' }) end, },
    })
  end,
}
