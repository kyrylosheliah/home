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
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    opts = {},
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
      "nvim-lua/plenary.nvim",
    },
    opts = {
      handlers = {
        function(config) -- default handler
          -- all sources with no handler get passed here
          require("mason-nvim-dap").default_setup(config)
        end,
      },
    },
  },

}
