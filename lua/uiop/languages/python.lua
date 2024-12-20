return {

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "python",
        "toml",
        "rst",
        "ninja",
        "markdown",
        "markdown_inline",
      },
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        --"python-lsp-server", -- (or pylsp) ```pip install python-lsp-server```
        "pyright",
        "taplo",
      },
      handlers = {
        ["pyright"] = function()
          local lsp = require(vim.g.username .. ".base.lsp")
          require("lspconfig").pyright.setup({
            capabilities = lsp.spawn_common_capabilities(),
            on_attach = lsp.spawn_on_attach({
              apply_indent = lsp.apply_indent(true, 2),
            }),
            root_dir = lsp.common_root_dir,
            filetypes = {
              "python",
            },
          })
        end,
        ["taplo"] = function()
          local lsp = require(vim.g.username .. ".base.lsp")
          require("lspconfig").taplo.setup({
            capabilities = lsp.spawn_common_capabilities(),
            on_attach = lsp.spawn_on_attach(),
            root_dir = lsp.common_root_dir,
            filetypes = {
              "toml",
            },
          })
        end,
        ["ruff"] = function()
          local lsp = require(vim.g.username .. ".base.lsp")
          require("lspconfig").ruff.setup({
            capabilities = lsp.spawn_common_capabilities(),
            on_attach = lsp.spawn_on_attach({
              disable = {
                hover = true,
                definition = true,
                completion = true,
              },
            }),
            root_dir = lsp.common_root_dir,
            filetypes = {
              "python",
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
        "flake8",
        "ruff", -- linter & formatter (includes flake8, pep8, black, isort, etc.)
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        python = { "flake8" },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "isort", "black" },
      },
    },
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = {
        "debugpy",
      },
    },
  },

  {
    "mfussenegger/nvim-dap-python",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      -- fix: E5108: Error executing lua .../Local/nvim-data/lazy/nvim-dap-ui/lua/dapui/controls.lua:14: attempt to index local 'element' (a nil value)
      -- see: https://github.com/rcarriga/nvim-dap-ui/issues/279#issuecomment-1596258077
      require("dapui").setup()
      -- uses the debugypy installation by mason
      local debugpyPythonPath = require("mason-registry").get_package("debugpy"):get_install_path()
      .. "/venv/bin/python3"
      require("dap-python").setup(debugpyPythonPath, {}) ---@diagnostic disable-line: missing-fields
    end,
  },

  --[[{
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = {
        "debugpy",
      },
      adapters = {
        debugpy = {
          type = "executable",
          command = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python",
          args = { "-m", "debugpy.adapter" },
        },
      },
      handlers = {
        python = function(config)
          config.{ -- wtf
          {
            type = "python",
            request = "launch",
            name = "Launch",
            program = function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            pythonPath = function()
              local venv_path = os.getenv("VIRTUAL_ENV")
              if venv_path then
                return venv_path .. "/bin/python"
              end
              local debugpy_python = require("mason-registry").get_package("debugpy"):get_install_path() .. "/venv/bin/python3"
              --vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
              if vim.fn.executable(debugpy_python) == 1 then
                return vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
              else
                return "python"
              end
            end
          },
        }
        end,
      },
    },
  },]]

}
