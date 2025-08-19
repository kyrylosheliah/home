local lsp = require("base.lsp")
lsp.configure("pyright", {
  on_attach = function(client, bufnr)
    lsp.apply_indent({
      use_tabs = false,
      space_count = 4,
    })
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
