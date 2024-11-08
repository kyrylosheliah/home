return {

  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    tag = "stable",
    opts = function(_)
      require("crates").setup({
        completion = {
          cmp = { enabled = true },
        },
      })
      require("cmp").setup.buffer({
        sources = { { name = "crates" } }
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "rust",
        "ron",
        "toml",
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
        "codelldb",
        --"rust-analyzer", -- will use system installation
        --"rustfmt", -- deprecated, install via rustup
        "taplo",
      },
    },
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = { "rust" },
    lazy = false,
    dependencies = {
      "williamboman/mason.nvim", -- for codelldb detection
    },
    --[[opts = function(_, opts)
      local mason_registry = require("mason-registry")
      local codelldb = mason_registry.get_package("codelldb")
      local extension_path = codelldb:get_install_path() .. "/extension/"
      local codelldb_path = extension_path .. "adapter/codelldb"
      --local liblldb_path = extension_path .. "lldb/lib/liblldb.lib"
      local cfg = require("rustaceanvim.config")
      adapter = {
        type = "server",
        port = "${port}",
        host = "127.0.0.1",
        executable = {
          command = codelldb_path,
          args = { "--port", "${port}" },
        },
      }
      --adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
      local more_opts = {
        server = {
          server = {
            on_attach = function(_, bufnr)
              vim.keymap.set("n", "<leader>cR", function()
                vim.cmd.RustLsp("codeAction")
              end, { desc = "Code Action", buffer = bufnr })
              vim.keymap.set("n", "<leader>dr", function()
                vim.cmd.RustLsp("debuggables")
              end, { desc = "Rust Debuggables", buffer = bufnr })
            end,
            default_settings = {
              -- rust-analyzer language server configuration
              ["rust-analyzer"] = {
                cargo = {
                  allFeatures = true,
                  loadOutDirsFromCheck = true,
                  buildScripts = {
                    enable = true,
                  },
                },
                -- Add clippy lints for Rust.
                checkOnSave = true,
                procMacro = {
                  enable = true,
                  ignored = {
                    ["async-trait"] = { "async_trait" },
                    ["napi-derive"] = { "napi" },
                    ["async-recursion"] = { "async_recursion" },
                  },
                },
              },
            },
          },
        },
        dap = { -- is detected automatically
          adapter = adapter,
        },
      }
      opts = vim.tbl_deep_extend('force', opts, more_opts)
      --require("rustaceanvim").setup(opts)
    end,]]
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
      },
    },
    --config = function() end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "saecki/crates.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "taplo",
      },
      servers = {
        taplo = {
          keys = {
            {
              "K",
              function()
                if vim.fn.expand("%:t") == "Cargo.toml" and require("crated").popup_available() then
                  require("crates").show_popup()
                else
                  vim.lsp.buf.hover()
                end
              end,
              desc = "Show Create Documentation",
            },
          },
        },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        rust = { "rustfmt" },
      },
    },
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "mrcjkb/rustaceanvim",
    },
    opts = {
      adapters = {
        ["rustaceanvim.neotest"] = {},
      },
    },
  },

}

