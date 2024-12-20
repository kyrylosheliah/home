return {

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "zig",
      },
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "zls",
      },
      handlers = {
        ["zls"] = function()
          vim.g.zig_fmt_autosave = 0
          local lsp = require(vim.g.username .. ".base.lsp")
          require("lspconfig").zls.setup({
            capabilities = lsp.spawn_common_capabilities(),
            on_attach = lsp.spawn_on_attach({
              apply_indent = lsp.apply_indent(true, 4),
            }),
            root_dir = lsp.common_root_dir,
            filetypes = {
              "zig",
              "zir",
            },
            --[[settings = {
            },]]
          })
        end,
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        zig = { "zig fmt" },
      },
    },
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = {
        "codelldb",
      },
      adapters = {
        nlua = function(callback, config)
          callback({ type = "server", host = config.host, port = config.port })
        end,
      },
      configurations = {
        lua = {
          {
            type = "nlua",
            request = "attach",
            name = "Attach to running Neovim instance",
            host = function()
              local value = vim.fn.input("Host [127.0.0.1]: ")
              if value ~= "" then
                return value
              end
              return "127.0.0.1"
            end,
            port = function()
              local value = tonumber(vim.fn.input("Port: "))
              assert(value, "Please provide a port number")
              if value ~= "" then
                return value
              end
              return 8086
            end,
          },
        },
      },
    },
  },

}
