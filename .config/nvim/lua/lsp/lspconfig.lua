return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "j-hui/fidget.nvim",
    "saghen/blink.cmp",
  },
  opts = {},
  config = function()
    vim.lsp.config("*", {
      capabilities = require("base.lsp").get_capabilities(),
      --on_attach = lsp.spawn_on_attach(),
      flags = {
        debounce_text_changes = 250,
      },
      --autostart = true,
      --root_dir = function(fname)
      --  return vim.fn.getcwd() and require("lspconfig/util").find_git_ancestor(fname)
      --end,
    })
    local goto_prev = function(severity)
      return function()
        vim.diagnostic.jump({
          count = -1,
          severity = severity and vim.diagnostic.severity[severity] or nil
        })
      end
    end
    local goto_next = function(severity)
      return function()
        vim.diagnostic.jump({
          count = 1,
          severity = severity and vim.diagnostic.severity[severity] or nil
        })
      end
    end
    local telescope_builtin = require('telescope.builtin')
    local conform = require("conform")
    local menu_key = "lsp"
    vim.keymap.set({ "n", "x" }, "<leader>l", function() require("base.command").open_menu(menu_key) end, { desc = "run lsp command" })
    require("base.command").add_menu_commands(menu_key, {
      { name = "hover symbol", cmd = vim.lsp.buf.hover, },
      { name = "rename symbol", cmd = vim.lsp.buf.rename, },
      { name = "execute code action", cmd = vim.lsp.buf.code_action, },
      --
      { name = "go to document symbol", cmd = vim.lsp.buf.document_symbol, },
      { name = "find document symbols", cmd = telescope_builtin.lsp_document_symbols, },
      { name = "go to workspace symbol", cmd = vim.lsp.buf.workspace_symbol, },
      { name = "find workspace symbols", cmd = telescope_builtin.lsp_dynamic_workspace_symbols, },
      { name = "go to references", cmd = vim.lsp.buf.references, },
      { name = "find references", cmd = telescope_builtin.lsp_references, },
      { name = "go to implementation", cmd = vim.lsp.buf.implementation, },
      { name = "find implementations", cmd = telescope_builtin.lsp_implementations, },
      { name = "go to definition", cmd = vim.lsp.buf.definition, },
      { name = "find definitions", cmd = telescope_builtin.lsp_definitions, },
      { name = "go to declaration", cmd = vim.lsp.buf.declaration, },
      { name = "find declarations", cmd = telescope_builtin.lsp_declarations, },
      { name = "go to type definition", cmd = vim.lsp.buf.type_definition, },
      { name = "find type definitions", cmd = telescope_builtin.lsp_type_definitions, },
      --
      { name = "toggle inlay hints", cmd = function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })) end, },
      --{ name = "format", cmd = function() vim.lsp.buf.format({ bufnr = 0, async = true }) end, },
      { name = "format range", cmd = function()
        local start_row, _ = unpack(vim.api.nvim_buf_get_mark(0, "<"))
        local end_row, _ = unpack(vim.api.nvim_buf_get_mark(0, ">"))
        vim.lsp.buf.format({
          range = {
            ["start"] = { start_row, 0 },
            ["end"] = { end_row, 0 },
          },
          async = true,
          bufnr = 0,
        })
      end, },
      { name = "format", cmd = function() conform.format({ async = true, lsp_fallback = true }) end, },
      { name = "go to signature help", cmd = vim.lsp.buf.signature_help, },
      { name = "run code lens", cmd = vim.lsp.codelens.run, },
      { name = "refresh code lens", cmd = vim.lsp.codelens.refresh, },
      --
      { name = "add to workspace folder", cmd = vim.lsp.buf.add_workspace_folder, },
      { name = "remove workspace folder", cmd = vim.lsp.buf.remove_workspace_folder, },
      { name = "list workspace folders", cmd = vim.lsp.buf.list_workspace_folders, },
      { name = "incoming calls", cmd = vim.lsp.buf.incoming_calls, },
      { name = "outgoing calls", cmd = vim.lsp.buf.outgoing_calls, },
      --
      { name = "find diagnostics", cmd = telescope_builtin.diagnostics, },
          { name = "open diagnostics", cmd = vim.diagnostic.open_float, },
          { name = "next diagnostics", cmd = function() vim.diagnostic.jump({ count = 1, }) end, },
          { name = "prev diagnostics", cmd = function() vim.diagnostic.jump({ count = -1, }) end, },
      { name         =
        "next diagnostics error", cmd = function() goto_next("ERROR") end, },
      { name = "prev diagnostics error", cmd = function() goto_prev("ERROR") end, },
      { name = "next diagnostics warning", cmd = function() goto_next("WARN") end, },
      { name = "prev diagnostics warning", cmd = function() goto_prev("WARN") end, },
      { name = "set diagnostics loclist", cmd = vim.diagnostic.setloclist, },
      { name = "set diagnostics quickfixlist", cmd = vim.diagnostic.setqflist, },
    })
  end,
}
