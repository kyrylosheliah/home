return {

  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        --"python-lsp-server", -- (or pylsp) ```pip install python-lsp-server```
        "pyright",
      },
      handlers = {
        ["pyright"] = function()
          local lsp = require(vim.g.username .. ".base.lsp")
          require("lspconfig").pyright.setup({
            capabilities = lsp.common_capabilities(),
            on_attach = lsp.common_on_attach(),
            root_dir = lsp.common_root_dir(),
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
        "isort",
        "black",
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
    "mfussenegger/nvim-dap",
    opts = {
      adapters = {
        python = {
          type = "executable",
          command = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python",
          args = { "-m", "debugpy.adapter" },
        },
      },
      configurations = {
        python = {
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
              if vim.fn.executable(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python") == 1 then
                return vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
              else
                return "python"
              end
            end
          },
        },
      },
    },
  },

}
