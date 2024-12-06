return {

  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "lua_ls",
      },
      handlers = {
        ["lua_ls"] = function()
          local capabilities = vim.lsp.protocol.make_client_capabilities()
          capabilities.textDocument.completion.completionItem["snippetSupport"] = true
          capabilities.textDocument.completion.completionItem["resolveSupport"] = {
            properties = {
              "documentation",
              "detail",
              "additionalTextEdits",
            },
          }
          local cmp_nvim_lsp = require("cmp_nvim_lsp")
          capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
          capabilities.experimental = {
            workspaceWillRename = true,
          }
          require("lspconfig").lua_ls.setup({
            filetypes = {
              "lua",
            },
            capabilities = capabilities,
            settings = {
              Lua = {
                format = {
                  enable = false,
                },
                hint = {
                  enable = true,
                  arrayIndex = "All",
                  await = true,
                  paramName = "All",
                  paramType = true,
                  semicolon = "Disable",
                  setType = true,
                },
                runtime = {
                  version = "Lua 5.1", --"LuaJIT",
                  special = {
                    reload = "require",
                  },
                },
                diagnostics = {
                  globals = {
                    --"bit",
                    --"it",
                    --"describe",
                    --"before_each",
                    --"after_each",
                    "vim",
                    "use",
                    "packer_plugins",
                    "NOREF_NOERR_TRUNC",
                  },
                },
                telemetry = {
                  enable = false,
                },
              },
            },
          })
        end,
      },
    },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        --"selene",
      },
    },
  },

  --[[{
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        lua = { "selene" },
      },
    },
  },]]

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
      },
    },
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = {
        --"nlua", -- isn't there, you know...
      },
    },
  },

-- local dap = require("dap")
  {
    "mfussenegger/nvim-dap",
    opts = {
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
