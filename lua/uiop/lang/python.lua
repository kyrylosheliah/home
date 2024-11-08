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
          local lspCapabilities = vim.lsp.protocol.make_client_capabilities()
          lspCapabilities.textDocument.completion.completionItem.snippetSupport = true
          require("lspconfig").pyright.setup({
            capabilities = lspCapabilities,
          })
        end,
        --["taplo"] = function()
          -- same as pyright??
        --end,
        ["ruff"] = function()
          require("lspconfig").ruff.setup({
            settings = {
              organizeImports = false,
            },
            -- disable ruff as hover provider to avoid conflicts with pyright
            on_attach = function(client) client.server_capabilities.hoverProvider = false end,
          })
        end,
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

--[[  {
    "Vigemus/iron.nvim",
    keys = {
      { "<leader>i", vim.cmd.IronRepl, desc = "󱠤 Toggle REPL" },
      { "<leader>I", vim.cmd.IronRestart, desc = "󱠤 Restart REPL" },

      -- these keymaps need no right-hand-side, since that is defined by the
      -- plugin config further below
      { "+", mode = { "n", "x" }, desc = "󱠤 Send-to-REPL Operator" },
      { "++", desc = "󱠤 Send Line to REPL" },
    },

    -- since irons's setup call is `require("iron.core").setup`, instead of
    -- `require("iron").setup` like other plugins would do, we need to tell
    -- lazy.nvim which module to via the `main` key
    main = "iron.core",

    opts = {
      keymaps = {
        send_line = "++",
        visual_send = "+",
        send_motion = "+",
      },
      config = {
        -- This defines how the repl is opened. Here, we set the REPL window
        -- to open in a horizontal split to the bottom, with a height of 10.
        repl_open_cmd = "horizontal bot 10 split",

        -- This defines which binary to use for the REPL. If `ipython` is
        -- available, it will use `ipython`, otherwise it will use `python3`.
        -- since the python repl does not play well with indents, it's
        -- preferable to use `ipython` or `bypython` here.
        -- (see: https://github.com/Vigemus/iron.nvim/issues/348)
        repl_definition = {
          python = {
            command = function()
              local ipythonAvailable = vim.fn.executable("ipython") == 1
              local binary = ipythonAvailable and "ipython" or "python3"
              return { binary }
            end,
          },
        },
      },
    },
  },]]

  {
    "mfussenegger/nvim-dap-python",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      local debugpyPythinPath = require("mason-registry").get_package("debugpy"):get_install_path() .. "/venv/bin/python3"
      require("dap-python").setup(debugpyPythonPath, {}) ---@diagnostics disable-line: missing-fields
    end,
  },

  --[[{
    "danymap/neogen",
    opts = true,
    keys = {
      {
        "<leader>ca",
        function() require("neogen").generate() end,
        desc = "add docstring",
      },
    },
  }]]

  {
    "chrisgrieser/nvim-puppeteer",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  }
}
