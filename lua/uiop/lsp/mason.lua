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
    opts = {
      ensure_installed = {
        -- RUST
        --"codelldb",
        --"rustfmt", -- deprecated, install via rustup
      },
    },
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
          require("mason-nvim-dap").default_setup(config)
        end,
      },
    },
  },

}
