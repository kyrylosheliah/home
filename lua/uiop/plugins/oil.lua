return {
  'stevearc/oil.nvim',
  dependencies = {
    "nvim-tree/nvim-web-devicons"
  },
  opts = {},
  keys = {
    { "-", vim.cmd.Oil, mode = "n", desc = "parent directory" },
  },
}
