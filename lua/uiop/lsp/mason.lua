return {

  {
    "williamboman/mason.nvim",
    opts = {
      ui = {
        icons = {
          package_installed = "i",
          package_pending = "p",
          package_uninstalled = "u",
        },
      },
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = function(_, opts)
      --local mason_lspconfig = require("mason-lspconfig")
      local lspconfig = require("lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = cmp_nvim_lsp.default_capabilities()
      local variable_opts = {
        handlers = {
          -- default handler for installed servers
          function(server_name)
            lspconfig[server_name].setup({
              capabilities = capabilities,
            })
          end,
        },
      }
      opts = vim.tbl_deep_extend('force', opts, variable_opts)
      return opts
    end,
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {},
    },
  },

}
