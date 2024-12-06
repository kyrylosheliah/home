--'Issafalcon/lsp-overloads.nvim'

return {

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "taplo", -- toml
        -- LUA
        "lua_ls",
        -- PYTHON
        "pyright",
        -- RUST
        "rust_analyzer", -- will use system installation if rustaceanvim is installed
      },
      handlers = {
        function(server_name) -- default handler
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
          --capabilities = vim.tbl_deep_extend("force", {}, capabilities, cmp_lsp.default_capabilities())
          -- what's the difference? so many questions, so little answers
          capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
          capabilities.experimental = {
            workspaceWillRename = true,
          }
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
            on_attach = function(client, bufnr)
              -- thank's, lvim
              -- START KEYMAPS
              -- KEYMAPS SHOULD BE HERE
              -- END KEYMAPS
              if client.server_capabilities.completionProvider then -- ?????
                vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
              end
              if client.server_capabilities.definitionProvider then -- tOdO hehe ?????
                vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
              end
              if client.server_capabilities.documentHighlightProvider then
                vim.api.nvim_create_autocmd("CursorHold", {
                  buffer = bufnr,
                  command = "lua vim.lsp.buf.document_highlight()",
                  group = "LvimIDE",
                })
                vim.api.nvim_create_autocmd("CursorMoved", {
                  buffer = bufnr,
                  command = "lua vim.lsp.buf.clear_references()",
                  group = "LvimIDE",
                })
              end
              if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint ~= nil then
                -- vim.lsp.inlay_hint(bufnr, true)
                -- vim.lsp.inlay_hint.enable(bufnr, true)
                vim.lsp.inlay_hint.enable(true, { bufnr })
              end
              --[[if client.server_capabilities.documentSymbolProvider then
                local navic = require("nvim-navic")
                navic.attach(client, bufnr)
              end]]
            end,
            --[[flags = {
              debounce_text_changes = 150,
            },]]
            --autostart = true,
            --[[root_dir = function(fname)
              return vim.fn.getcwd()
            end,]]
          })
        end,
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

      require("mason").setup()

      local lspconfig = require("lspconfig")
      local mason_lspconfig = require("mason-lspconfig")
      local cmp_lsp = require("cmp_nvim_lsp")

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend(
        "force", {}, capabilities, cmp_lsp.default_capabilities())

      mason_lspconfig.setup_handlers({
      })

    end,
  },

}
