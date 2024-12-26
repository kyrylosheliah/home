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
    "SirZenith/oil-vcs-status",
    dependencies = {
      "stevearc/oil.nvim",
    },
    setup = function(_)
      --[[local vsc_status= require("oil-vcs-status")
      local status_const = require("oil-vcs-status.constant.status")
      local StatusType = status_const.StatusType]]
      require("oil-vcs-status").setup({})
    end,
  },
}
