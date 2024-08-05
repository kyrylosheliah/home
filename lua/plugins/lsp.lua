return {
  {
    event = { 'BufReadPre', 'BufNewFile' },
    'neovim/nvim-lspconfig',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      vim.diagnostic.config({
        virtual_text = true,
        signs = false,
        underline = true,
      })
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
          keymap.set('n', 'gl', vim.diagnostic.open_float)
          keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

          opts.desc = "Go to previous diagnostic"
          keymap.set('n', '[d', vim.diagnostic.goto_prev)

          opts.desc = "Go to next diagnostic"
          keymap.set('n', ']d', vim.diagnostic.goto_next)

          --keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

          opts.desc = "Restart LSP"
          keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
        end,
      })

      local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      local lspconfig = require('lspconfig')
      local mason_lspconfig = require("mason-lspconfig")
      local cmp_nvim_lsp = require('cmp_nvim_lsp')
      local capabilities = cmp_nvim_lsp.default_capabilities()

      mason_lspconfig.setup_handlers({
        -- default handler for installed servers
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = capabilities,
          })
        end,
        --[[["pyright"] = function()
          lspconfig["pyright"].setup({})
        end,]]
        ["lua_ls"] = function()
          lspconfig["lua_ls"].setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                -- make the language server recognize "vim" global
                diagnostics = {
                  globals = { "vim" },
                },
                completion = {
                  callSnippet = "Replace",
                },
              },
            },
          })
        end,
        ["emmet_ls"] = function()
          lspconfig["emmet_ls"].setup({
            capabilities = capabilities,
            filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less" },
          })
        end,
        ['unocss'] = function()
          lspconfig['unocss'].setup({
            filetypes = { "html", "javascriptreact", "javascript", "typescript", "typescriptreact", "vue", "svelte" },
            root_dir = lspconfig.util.root_pattern('unocss.config.js', 'unocss.config.ts', 'uno.config.js',
              'uno.config.ts'),
          })
        end,
      })
    end,
  },

  {
    'williamboman/mason.nvim',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      require('mason').setup({
        ui = {
          icons = {
            package_installed = 'i',
            package_pending = 'p',
            package_uninstalled = 'u',
          },
        },
      })

      require("mason-lspconfig").setup({
        ensure_installed = {
          "tsserver",
          "html",
          "cssls",
          "tailwindcss",
          "unocss",
          "lua_ls",
          "emmet_ls",
          "pyright",
        },
        automatic_installation = true,
      })

      require("mason-tool-installer").setup({
        ensure_installed = {
          "prettier", -- prettier formatter
          "stylua",   -- lua formatter
          "black", -- python formatter
          "flake8", -- python linter
        },
      })
    end
  },

  {
    event = 'InsertEnter',
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',
    },
    config = function()
      local cmp = require('cmp')
      local cmp_select = { behavior = cmp.SelectBehavior.Select }
      require('luasnip.loaders.from_vscode').lazy_load()
      cmp.setup({
        experimental = {
          ghost_text = { hl_group = "Whitespace" },
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        sources = {
          --{ name = "codeium" },
          { name = 'luasnip' },
          { name = 'nvim_lsp' },
          { name = "path" },
          { name = "buffer" },
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
          ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
          --['<C-f>'] = cmp_action.luasnip_jump_forward(),
          --['<C-b>'] = cmp_action.luasnip_jump_backward(),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-y>'] = cmp.mapping.confirm({ select = true }),
          ['<S-Tab>'] = nil,
          ['<S>'] = nil,
        }),
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
      })
    end,
  }
}
