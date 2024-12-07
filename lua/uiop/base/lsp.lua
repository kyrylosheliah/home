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

-- ==============

M = {}

M.common_capabilities = function()
  return require("cmp_nvim_lsp").default_capabilities(
    vim.lsp.protocol.make_client_capabilities())
end

M.common_on_attach = function()
  return function(client, bufnr)
    -- Keymaps should be here
    if client.server_capabilities.completionProvider then
      vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    end
    if client.server_capabilities.definitionProvider then
      vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
    end
    if client.server_capabilities.documentHighlightProvider then
      local group = vim.api.nvim_create_augroup("base.lsp", { clear = true })
      vim.api.nvim_create_autocmd("CursorHold", {
        buffer = bufnr,
        command = "lua vim.lsp.buf.document_highlight()",
        group = group,
      })
      vim.api.nvim_create_autocmd("CursorMoved", {
        buffer = bufnr,
        command = "lua vim.lsp.buf.clear_references()",
        group = group,
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
    if client.server_capabilities.signatureHelpProvider then
      require("lsp-overloads").setup(client, {
        keymaps = {
          next_signature = "<A-j>",
          previous_signature = "<A-k>",
          next_parameter = "<A-l>",
          previous_parameter = "<A-h>",
          close_signature = "<A-n>"
        },
      })
    end
  end
end

M.common_root_dir = function()
  return function(fname)
    return require("lspconfig/util").find_git_ancestor(fname)
      or vim.fn.getcwd()
  end
end

return M
