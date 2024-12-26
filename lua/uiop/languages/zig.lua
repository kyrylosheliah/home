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
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "codelldb",
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
      handlers = {
        zig = function(config)
          config.adapters = {
            type = 'executable',
            command = 'C:\\Program Files\\LLVM\\bin\\lldb-vscode.exe', -- adjust as needed, must be absolute path
            name = 'lldb'
          }
          config.configurations = {
            {
              name = 'Launch',
              type = 'lldb',
              request = 'launch',
              program = '${workspaceFolder}/zig-out/bin/zig_hello_world.exe',
              cwd = '${workspaceFolder}',
              stopOnEntry = false,
              args = {},
            },
          }
        end,
      },
    },
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "lawrence-laz/neotest-zig",
    },
    opts = {
      adapters = {
        ["neotest-zig"] = {},
      },
    },
  },

}
