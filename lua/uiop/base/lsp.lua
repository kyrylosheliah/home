local lsp = vim.lsp
local user_command = vim.api.nvim_create_user_command

-- :LspRestart<CR> -- Restart LSP
user_command("LspHover", lsp.buf.hover, {})
user_command("LspRename", lsp.buf.rename, {})
-- :LspFormat
user_command("LspFormatAsync", "lua vim.lsp.buf.format {async = true}", {})
-- :LspFormatRange
user_command("LspFormatRangeAsync", function()
  local start_row, _ = unpack(vim.api.nvim_buf_get_mark(0, "<"))
  local end_row, _ = unpack(vim.api.nvim_buf_get_mark(0, ">"))
  vim.lsp.buf.format({
    range = {
      ["start"] = { start_row, 0 },
      ["end"] = { end_row, 0 },
    },
    async = true,
  })
end, {})
user_command("LspCodeAction", lsp.buf.code_action, {})
user_command("LspDefinition", lsp.buf.definition, {})
user_command("LspTypeDefinition", lsp.buf.type_definition, {})
user_command("LspDeclaration", lsp.buf.declaration, {})
user_command("LspReferences", lsp.buf.references, {})
user_command("LspImplementation", lsp.buf.implementation, {})
user_command("LspSignatureHelp", lsp.buf.signature_help, {})
user_command("LspDocumentSymbol", lsp.buf.document_symbol, {})
user_command("LspWorkspaceSymbol", lsp.buf.workspace_symbol, {})
user_command("LspCodeLensRefresh", lsp.codelens.refresh, {})
user_command("LspCodeLensRun", lsp.codelens.run, {})
user_command("LspAddToWorkspaceFolder", lsp.buf.add_workspace_folder, {})
user_command("LspRemoveWorkspaceFolder", lsp.buf.remove_workspace_folder, {})
user_command("LspListWorkspaceFolders", lsp.buf.list_workspace_folders, {})
user_command("LspIncomingCalls", lsp.buf.incoming_calls, {})
user_command("LspOutgoingCalls", lsp.buf.outgoing_calls, {})
user_command("LspClearReferences", lsp.buf.clear_references, {})
user_command("LspDocumentHighlight", lsp.buf.document_highlight, {})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("keymap on LspAttach", {}),
  callback = function(event)
    local opts = { buffer = event.buf, silent = true }
    local keymap = vim.keymap
    opts.desc = "Show buffer diagnostics"
    keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file
    opts.desc = "Show line diagnostics"
    keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file
  end,
})
