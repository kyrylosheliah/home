return {

  {
    "williamboman/mason.nvim",
    opts = {
      ui = {
        icons = {
          package_installed = "i",
          package_pending = "p",
          package_uninstalled = "u",
        },
      },
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        -- LUA
        "lua_ls",
      },
      handlers = {
        --[[function(server_name) -- default handler
        require("lspconfig")[server_name].setup({
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
        })
      end,]]
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
        -- LUA
        "stylua",
        "selene",
        -- PYTHON
        "pyright",
        "ruff",
        "debugpy",
        "black",
        "isort",
        "taplo",
        -- 
      },
    },
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      ensure_installed = {},
      handlers = {
        --[[function(config) -- default handler
          require("mason-nvim-dap").default_setup(config)
        end,]]
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    --event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/nvim-cmp",
    },
    config = function(_, opts)

      vim.diagnostic.config({
        virtual_text = true,
        signs = false,
        underline = true,
      })

      --[[local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end]]

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(event)
          local opts = { buffer = event.buf, silent = true }
          local keymap = vim.keymap

          opts.desc = "Show hover documentation"
          keymap.set("n", "K", vim.lsp.buf.hover, opts)

          opts.desc = "Show LSP definitions"
          keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          --keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

          opts.desc = "Go to declaration"
          keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

          opts.desc = "Show LSP implementations"
          keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          --keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

          opts.desc = "Show LSP type definitions"
          keymap.set("n", "gt", vim.lsp.buf.type_definition, opts) -- was 'go'
          --keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

          opts.desc = "Show LSP references"
          keymap.set("n", "gr", vim.lsp.buf.references, opts)
          --keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

          opts.desc = "Show LSP signature_help"
          keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)

          opts.desc = "Smart rename"
          keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)

          keymap.set("n", "<F3>", vim.lsp.buf.format, opts)
          --vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)

          opts.desc = "See available code actions"
          keymap.set("n", "<F4>", vim.lsp.buf.code_action, opts)

          keymap.set("n", "<F5>", vim.lsp.buf.workspace_symbol, opts)

          opts.desc = "Show buffer diagnostics"
          keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

          opts.desc = "Show line diagnostics"
          keymap.set("n", "gl", vim.diagnostic.open_float)
          keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

          opts.desc = "Go to previous diagnostic"
          keymap.set("n", "[d", vim.diagnostic.goto_prev)

          opts.desc = "Go to next diagnostic"
          keymap.set("n", "]d", vim.diagnostic.goto_next)

          --keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

          opts.desc = "Restart LSP"
          keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
        end,
      })

      require("mason").setup()

      local lspconfig = require("lspconfig")
      --local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")
      local cmp_lsp = require("cmp_nvim_lsp")

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend(
        "force", {}, capabilities, cmp_lsp.default_capabilities())

      mason_lspconfig.setup_handlers({
        function(server_name)
          require("lspconfig")[server_name].setup {
            capabilities = capabilities,
          }
        end,
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup {
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = { version = "Lua 5.1" },
                diagnostics = {
                  globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                },
              },
            },
          }
        end,
      })

    end,
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      linters_by_ft = {
        lua = { "selene" },
        --markdown = { "markdownlint" },
      },
    },
    config = function(_, opts)
      local debounce = function(ms, fn)
        local timer = vim.uv.new_timer()
        return function(...)
          local argv = { ... }
          timer:start(ms, 0, function()
            timer:stop()
            vim.schedule_wrap(fn)(unpack(argv))
          end)
        end
      end
      local lint_events = { "BufEnter", "BufReadPost", "BufWritePost", "InsertLeave" }
      local lint_augroup = vim.api.nvim_create_augroup("nvim-lint", { clear = true })
      vim.api.nvim_create_autocmd(lint_events, {
        group = lint_augroup,
        callback = debounce(1000, function()
          require("lint").try_lint()
        end),
      })
      --require("lint").setup(opts)
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      return {
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "isort", "black" },
          --markdown = { "inject" }, -- makes format python codeblocks inside a markdown file
          javascript = { "prettierd", "prettier", stop_after_first = true },
        },
        --[[format_on_save = {
          -- These options will be passed to conform.format()
          timeout_ms = 500,
          lsp_format = "fallback",
        },]]
      }
    end,
  },

}
