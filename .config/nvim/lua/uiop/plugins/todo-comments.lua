return {
  "folke/todo-comments.nvim",
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "]t", function() require("todo-comments").jump_next() end, desc = "next todo" },
    { "[t", function() require("todo-comments").jump_prev() end, desc = "previous todo" },
  },
  opts = {},
}
