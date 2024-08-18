return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    -- "3rd/image.nvim",
  },
  keys = {
    {
      "<leader>ef",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = vim.fn.fnamemodify(vim.fn.expand("%"), ":p:h") })
      end,
      desc = "explore files (root dir)",
    },
    {
      "<leader>eF",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = vim.fn.getcwd() })
      end,
      desc = "Explore files (cwd)",
    },
    {
      "<leader>eg",
      function()
        require("neo-tree.command").execute({ source = "git_status", toggle = true })
      end,
      desc = "explore git",
    },
    {
      "<leader>eb",
      function()
        require("neo-tree.command").execute({ source = "buffers", toggle = true })
      end,
      desc = "explore buffers",
    },
  },
  opts = {
    buffers = {
      follow_current_file = {
        enabled = true,
        leave_dirs_open = false, -- false is default
      },
    },
  },
}
