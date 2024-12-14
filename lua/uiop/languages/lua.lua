return {

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "lua",
        "luadoc",
        "luap",
      },
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "lua_ls",
      },
      handlers = {
        ["lua_ls"] = function()
          local lsp = require(vim.g.username .. ".base.lsp")
          require("lspconfig").lua_ls.setup({
            capabilities = lsp.spawn_common_capabilities(),
            on_attach = lsp.spawn_on_attach(),
            root_dir = lsp.common_root_dir,
            filetypes = {
              "lua",
            },
            settings = {
              Lua = {
                format = {
                  enable = true,
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
                  version = "LuaJIT",
                  special = {
                    reload = "require",
                  },
                },
                workspace = {
                  library = {
                    vim.env.VIMRUNTIME
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                  },
                },
                diagnostics = {
                  globals = {
                    "vim",
                  },
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
        --"luacheck",
      },
    },
  },

  --[[{
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        --lua = { "selene" },
        lua = { "luacheck" },
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

  --[[
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = {
        --"nlua", -- isn't there, you know...
      },
    },
  },

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
  ]]

}
