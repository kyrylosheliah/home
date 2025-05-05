return {

  {
    "stevearc/aerial.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {
      attach_mode = "global", -- "window"
      backends = { "treesitter", "lsp", "markdown", "asciidoc", "man" },
      show_guides = true, -- false
      layout = {
        resize_to_content = false,
        win_opts = {
          winhl = "Normal:NormalFloat,FloatBorder:NormalFloat,SignColumn:SignColumnSB",
          signcolumn = "yes",
          statuscolumn = " ",
        },
      },
    },
    keys = {
      { "<leader>cs", "<cmd>AerialToggle<cr>", desc = "Aerial (Symbols)" },
    },
  },

}
