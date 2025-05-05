return {
  'tpope/vim-fugitive',
  keys = {
    { "<leader>g", "", desc = "+git" },
    {
      "<leader>gs",
      vim.cmd.Git,
      mode = "n",
      desc = "git status",
    },
  },
}
