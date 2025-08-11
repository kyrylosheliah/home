local function is_in_git_repo()
  return 0 ~= #(vim.fs.find(
    { '.git' },
    { limit = 1, type = 'directory', path = "./" }))
end

return {
  {
    'stevearc/oil.nvim',
    dependencies = {
      "nvim-tree/nvim-web-devicons"
    },
    opts = {
      columns = {
        --"icon",
        --"permissions",
        --"size",
        --"mtime",
      },
      view_options = {
        show_hidden = true,
      },
      git = {
        add = function(path)
          return is_in_git_repo()
        end,
        mv = function(src_path, dest_path)
          return is_in_git_repo()
        end,
        rm = function(path)
          return is_in_git_repo()
        end,
      },
      win_options = {
        signcolumn = "yes:2",
      },
    },
    keys = {
      { "<leader>-", vim.cmd.Oil, mode = "n", desc = "parent (directory) (oil)" },
    },
  },

  {
    "refractalize/oil-git-status.nvim",
    dependencies = { "stevearc/oil.nvim" },
    config = true,
  },

  {
    "JezerM/oil-lsp-diagnostics.nvim",
    dependencies = { "stevearc/oil.nvim" },
    opts = {}
  },
}
