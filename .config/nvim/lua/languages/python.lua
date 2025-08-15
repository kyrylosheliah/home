local lsp = require("base.lsp")
lsp.configure("pyright", {
  on_attach = function(client, bufnr)
    lsp.apply_indent(false, 4)
  end,
})

return {

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "python",
      },
    },
  },

  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "pyright",
      },
    },
  },

}
