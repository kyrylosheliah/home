return {
  'stevearc/oil.nvim',
  dependencies = {
    "nvim-tree/nvim-web-devicons"
  },
  opts = {
    columns = {
      "icon",
      "permissions",
      --"size",
      "mtime",
    },
  },
  keys = {
    { "<leader>-", vim.cmd.Oil, mode = "n", desc = "explore parent ... directory" },
  },
}
