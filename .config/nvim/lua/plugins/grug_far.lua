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
    require("base.command").add_submenu_commands("search", {
      { name = "open grug far", cmd = grug_far.open, },
      { name = "grug far | word", cmd = function() grug_far.open({ prefills = { search = vim.fn.expand("<cword>") } }) end, },
      { name = "grug far | ast-grep engine", cmd = function() grug_far.open({ engine = 'astgrep' }) end, },
      { name = "grug far | transient buffer", cmd = function() grug_far.open({ transient = true }) end, },
      { name = "grug far | within current file", cmd = function() grug_far.open({ prefills = { paths = vim.fn.expand("%") } }) end, },
      { name = "grug far | selection", cmd = function() grug_far.with_visual_selection({ prefills = { paths = vim.fn.expand("%") } }) end, },
      { name = "grug far | within selection", cmd = function() grug_far.open({ visualSelectionUsage = 'operate-within-range' }) end, },
    })
  end,
}
