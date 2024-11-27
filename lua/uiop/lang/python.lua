if true then return {} end

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
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    opts = {
      ensure_installed = {
        "pyright",
        "ruff",
        "debugpy",
        "black",
        "isort",
        "taplo",
      },
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      'Issafalcon/lsp-overloads.nvim'
    },
    opts = {
      --ensure_installed = {
      ---},
      handlers = {
        ["pyright"] = function()
          local capabilities = vim.lsp.protocol.make_client_capabilities()
          --lspCapabilities.textDocument.completion.completionItem.snippetSupport = true
          capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
          require("lspconfig").pyright.setup({
            capabilities = capabilities,
          })
        end,
        --["taplo"] = function()
          -- same as pyright??
        --end,
        --[[["ruff"] = function()
          require("lspconfig").ruff.setup({
            settings = {
              organizeImports = false,
            },
            -- disable ruff as hover provider to avoid conflicts with pyright
            on_attach = function(client) client.server_capabilities.hoverProvider = false end,
          })
        end,]]
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "isort", "black" },
        -- "inject" is a special formatter from conform.nvim
        -- which formats treesitter-njected code
        -- it makes format python codeblocks inside a markdown file
        --markdown = { "inject" },
      }
    }
  },

  {
    "mfussenegger/nvim-dap-python",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      --local dap, dapui = require("dap"), require("dapui")
      --local debugpyPythinPath = require("mason-registry").get_package("debugpy"):get_install_path() .. "/venv/bin/python3"
      --require("dap-python").setup(debugpyPythonPath, {}) ---@diagnostics disable-line: missing-fields
      require("dap-python").setup("python")
    end,
  },

}
