local fallback_python_path = function()
  local venv_path = os.getenv("VIRTUAL_ENV")
  if venv_path then
    return venv_path .. "/bin/python"
  end
  local debugpy_python = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/Scripts/python"
  return (vim.fn.executable(debugpy_python) == 1) and debugpy_python or "python"
end

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
              apply_indent = lsp.apply_indent(true, 4),
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

  --[[{
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = {
        "python", -- debugpy
      },
      handlers = {
        python = function(config)
          config.adapters = {
            python = {
              type = "executable",
              command = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/Scripts/python",
              args = { "-m", "debugpy.adapter" },
            },
          }
          config.configurations = {
            python = {
              {
                type = "python",
                request = "launch",
                name = "Input executable",
                program = function()
                  return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                pythonPath = fallback_python_path,
              },
              {
                type = "python",
                request = "launch",
                name = "Current file",
                program = "${file}",
                pythonPath = fallback_python_path,
              },
            },
          }
          require("mason-nvim-dap").default_setup(config)
        end,
      },
    },
  },]]

  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mfussenegger/nvim-dap-python",
      -- stylua: ignore
      keys = {
        { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
        { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
      },
      config = function()
        if vim.fn.has("win32") == 1 then
          require("dap-python").setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/Scripts/pythonw.exe")
        else
          require("dap-python").setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")
        end
      end,
    },
  },
  -- Don't mess up DAP adapters provided by nvim-dap-python
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      handlers = {
        python = function() end,
      },
    },
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          -- Here you can specify the settings for the adapter, i.e.
          -- runner = "pytest",
          -- python = ".venv/bin/python",
        },
      },
    },
  },

  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp", -- Use this branch for the new version
    cmd = "VenvSelect",
    opts = {
      settings = {
        options = {
          notify_user_on_venv_activation = true,
        },
      },
    },
    --  Call config for python files and load the cached venv automatically
    ft = "python",
    keys = { { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" } },
  },

}
