return {
  enabled = false,
  "Exafunction/codeium.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "hrsh7th/nvim-cmp",
      opts = {
        sources = {
          { name = 'codeium' },
        },
      },
    },
  },
  opts = {},
}
