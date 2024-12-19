return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    --vim.o.timeout = true
    --vim.o.timeoutlen = 500
  end,
  --opts_extend = { "spec" },
  --opts = {
  --  spec = {
  --    { "<BS>", desc = "Decrement Selection", mode = "x" },
  --    { "<c-space>", desc = "Increment Selection", mode = { "x", "n" } },
  --  },
  --  defaults = {},
  --},
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Keymaps (which-key)",
    },
    {
      "<c-w><space>",
      function()
        require("which-key").show({ keys = "<c-w>", loop = true })
      end,
      desc = "Window Hydra Mode (which-key)",
    },
  },
}
