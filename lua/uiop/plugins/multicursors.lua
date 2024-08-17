return {
  enabled = false,
  "smoka7/multicursors.nvim",
  event = "VeryLazy",
  dependencies = {
    'smoka7/hydra.nvim',
  },
  opts = {},
  cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
  keys = {
    { "<leader>m", "", desc = "+multicursor" },
    {
      mode = { 'v', 'n' },
      '<Leader>ms',
      '<cmd>MCstart<cr>',
      desc = 'multicursor start',
    },
    {
      mode = { 'v', 'n' },
      '<Leader>mc',
      '<cmd>MCclear<cr>',
      desc = 'multicursor clear',
    },
  },
}
