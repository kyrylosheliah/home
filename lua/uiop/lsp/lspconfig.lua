return {
  "neovim/nvim-lspconfig",
  --event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    "williamboman/mason.nvim",
  },
  config = function()
    vim.diagnostic.config({
      virtual_text = false,
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

    local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

  end,
}
