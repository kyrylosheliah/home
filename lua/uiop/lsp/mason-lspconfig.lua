return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
    "Decodetalkers/csharpls-extended-lsp.nvim",
  },
  opts = {
    handlers = {
      -- default handler for installed servers
      function(server_name)
        require("lspconfig")[server_name].setup({
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
        })
      end,
    },
  },
}
