return {
  'tpope/vim-fugitive',
  config = function()
    vim.g.add_commands({
      { name = "git status", cmd = vim.cmd.Git },
    })
  end,
}
