return {
  "stevearc/aerial.nvim",
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    {
      "<leader>a",
      "<cmd>AerialToggle<cr>",
      desc = "Aerial (Symbols)"
    },
    {
      "<leader>ss",
      "<cmd>Telescope aerial<cr>",
      desc = "Goto Symbol (Aerial)",
    },
  },
  opts = {
    on_attach = function(bufnr)
      vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
      vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
    end,
  },
  config = function(_, opts)
    require("aerial").setup(opts)
    require("telescope").load_extension("aerial")
  end
}
