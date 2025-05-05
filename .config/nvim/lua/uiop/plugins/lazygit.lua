return {
  "kdheepak/lazygit.nvim",
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    { "<leader>l", "", desc = "+lazy" },
    {
      "<leader>lg",
      vim.cmd.LazyGit,
      mode = "n",
      desc = "lazy git"
    },
    {
      "<leader>lr",
      function() require("telescope").extensions.lazygit.lazygit() end,
      mode = "n",
      desc = "lazygit repos"
    },
  },
}
