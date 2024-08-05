return {
  "smoka7/multicursors.nvim",
  event = "VeryLazy",
  dependencies = {
    'smoka7/hydra.nvim',
  },
  opts = {},
  cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
  keys = {
    {
      mode = { 'v', 'n' },
      '<Leader>ms',
      '<cmd>MCstart<cr>',
      desc = '[M]ulticursor [S]tart',
    },
    {
      mode = { 'v', 'n' },
      '<Leader>mc',
      '<cmd>MCclear<cr>',
      desc = '[M]ulticursor [C]lear',
    },
  },
}
