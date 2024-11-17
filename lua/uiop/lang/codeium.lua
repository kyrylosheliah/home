return {
  enabled = false,
  "Exafunction/codeium.vim",
  event = "BufEnter",
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
  --opts = {},
  config = function()
--[[    vim.keymap.set("i", "<C-g>", function()
      return vim.fn["codeium#Accept"]()
    end, { expr = true, silent = true, desc = "Codeium Accept" })
    vim.keymap.set("i", "<C-x>", function()
      return vim.fn["codeium#Clear"]()
    end, { expr = true, silent = true, desc = "Codeium Clear" })
    vim.keymap.set("i", "<C-]>", function()
      return vim.fn["codeium#CycleCompletions"](1)
    end, { expr = true, silent = true, desc = "Codeium Cycle Completions Next" })
    vim.g.codeium_filetypes = {
      markdown = false,
    }]]
  end,
}
