return {
  'tpope/vim-fugitive',
  config = function()
    require("base.command").add_submenu_commands("git", {
      { name = "git status", cmd = vim.cmd.Git },
    })
  end,
}
