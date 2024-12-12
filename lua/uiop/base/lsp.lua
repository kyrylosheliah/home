vim.diagnostic.config({
  --[[virtual_text = {
    prefix = "█",--"💢",--"",
  },]]
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  signs = false,
  --[[signs = {
    text = {
      [diagnostic.severity.ERROR] = signs.Error,
      [diagnostic.severity.WARN] = signs.Warn,
      [diagnostic.severity.HINT] = signs.Hint,
      [diagnostic.severity.INFO] = signs.Info,
    },
  },]]
  float = {
    focusable = false,
    style = "minimal",
    --source = "always",
    --header = "",
    --prefix = "",
  },
})

local apply_default_keymaps = function(event)
  local bufnr = event.buf
  local command = vim.api.nvim_buf_create_user_command
  --vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", { buffer = bufnr, silent = true, desc = "Show buffer diagnostics" })
  --vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", { buffer = bufnr, silent = true, desc = "Show line diagnostics" })
  vim.keymap.set("n", "gd",
    vim.lsp.buf.definition,
    { noremap = true, silent = true, buffer = bufnr, desc = "LspDefinition" })
  vim.keymap.set("n", "gD",
    vim.lsp.buf.declaration,
    { noremap = true, silent = true, buffer = bufnr, desc = "LspDeclaration" })
  vim.keymap.set("n", "gt",
    vim.lsp.buf.type_definition,
    { noremap = true, silent = true, buffer = bufnr, desc = "LspTypeDefinition" })
  vim.keymap.set("n", "gr",
    vim.lsp.buf.references,
    { noremap = true, silent = true, buffer = bufnr, desc = "LspReferences" })
  vim.keymap.set("n", "gi",
    vim.lsp.buf.implementation,
    { noremap = true, silent = true, buffer = bufnr, desc = "LspImplementation" })
  vim.keymap.set("n", "ge",
    vim.lsp.buf.rename,
    { noremap = true, silent = true, buffer = bufnr, desc = "LspRename" })
  vim.keymap.set({ "n", "x" }, "gf", function()
    vim.lsp.buf.format({ --[[bufnr = bufnr,]] async = true })
  end, { noremap = true, silent = true, buffer = bufnr, desc = "LspFormat" })
  --[[vim.keymap.set("x", "g;", function()
    local start_row, _ = unpack(vim.api.nvim_buf_get_mark(0, "<"))
    local end_row, _ = unpack(vim.api.nvim_buf_get_mark(0, ">"))
    vim.lsp.buf.format({
      range = {
        ["start"] = { start_row, 0 },
        ["end"] = { end_row, 0 },
      },
      async = true,
      bufnr = bufnr,
    })
    end, { noremap = true, silent = true, buffer = bufnr, desc = "LspFormatRange" })]]
  vim.keymap.set("n", "ga",
    vim.lsp.buf.code_action,
    { noremap = true, silent = true, buffer = bufnr, desc = "LspCodeAction" })
  vim.keymap.set("n", "gs",
    vim.lsp.buf.signature_help,
    { noremap = true, silent = true, buffer = bufnr, desc = "LspSignatureHelp" })
  vim.keymap.set("n", "gL",
    vim.lsp.codelens.refresh,
    { noremap = true, silent = true, buffer = bufnr, desc = "LspCodeLensRefresh" })
  vim.keymap.set("n", "gl",
    vim.lsp.codelens.run,
    { noremap = true, silent = true, buffer = bufnr, desc = "LspCodeLensRun" })
  vim.keymap.set("n", "gh",
    vim.lsp.buf.hover,
    { noremap = true, silent = true, buffer = bufnr, desc = "LspHover" })
  vim.keymap.set("n", "K",
    vim.lsp.buf.hover,
    { noremap = true, silent = true, buffer = bufnr, desc = "LspHover" })
  command(bufnr, "LspDocumentSymbol", vim.lsp.buf.document_symbol, {})
  command(bufnr, "LspWorkspaceSymbol", vim.lsp.buf.workspace_symbol, {})
  command(bufnr, "LspAddToWorkspaceFolder", vim.lsp.buf.add_workspace_folder, {})
  command(bufnr, "LspRemoveWorkspaceFolder", vim.lsp.buf.remove_workspace_folder, {})
  command(bufnr, "LspListWorkspaceFolders", vim.lsp.buf.list_workspace_folders, {})
  command(bufnr, "LspIncomingCalls", vim.lsp.buf.incoming_calls, {})
  command(bufnr, "LspOutgoingCalls", vim.lsp.buf.outgoing_calls, {})
  -- ===========
  -- DIAGNOSTICS
  -- ===========
  local goto_prev = function(severity)
    return function()
      vim.diagnostic.goto_prev({
        severity = severity and vim.diagnostic.severity[severity] or nil
      })
    end
  end
  local goto_next = function(severity)
    return function()
      vim.diagnostic.goto_next({
        severity = severity and vim.diagnostic.severity[severity] or nil
      })
    end
  end
  vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { buffer = bufnr, desc = "Line Diagnostics" })
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr, desc = "Next Diagnostic" })
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "Prev Diagnostic" })
  vim.keymap.set("n", "]e", goto_next("ERROR"), { buffer = bufnr, desc = "Next Error" })
  vim.keymap.set("n", "[e", goto_prev("ERROR"), { buffer = bufnr, desc = "Prev Error" })
  vim.keymap.set("n", "]w", goto_next("WARN"), { buffer = bufnr, desc = "Next Warning" })
  vim.keymap.set("n", "[w", goto_prev("WARN"), { buffer = bufnr, desc = "Prev Warning" })
  command(bufnr, "DiagnosticsSetloclist", vim.diagnostic.setloclist, {})
  command(bufnr, "DiagnosticsQuickfixlist", vim.diagnostic.setqflist, {})
  vim.keymap.set("n", "<leader>th", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr }))
  end, { buffer = bufnr, desc = "Toggle Inlay Hints" })
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("keymap on LspAttach", {}),
  callback = apply_default_keymaps,
})

-- ==============

M = {}

M.spawn_common_capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
  return capabilities
end

M.spawn_on_attach = function(config)
  local disable = config and (config.disable == nil and {} or config.disable) or {}
  return function(client, bufnr)
    if disable.hover and not client.server_capabilities.hoverProvider then
      client.server_capabilities.hoverProvider = false
    end
    if not disable.definition and client.server_capabilities.definitionProvider then
      -- Enables "go to definition", <C-]> and other tag commands
      vim.api.nvim_set_option_value("tagfunc", "v:lua.vim.lsp.tagfunc", { buf = bufnr })
    end
    --[[if not disable.completion and client.server_capabilities.completionProvider then
      -- Enables (manual) omni mode competion with <C-X><C-O> in Insert mode. For autocompletion, an autocompletion plugin is required
      vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })
    end]]
    if not disable.formatting and client.server_capabilities.documentFormattingProvider then
      -- Enables LSP formatting with gq
      vim.api.nvim_set_option_value("formatexpr", 'v:lua.require("conform").formatexpr()', { buf = bufnr })
    end
    if not disable.highlight and client.server_capabilities.documentHighlightProvider then
      local group = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
      vim.api.nvim_create_autocmd("CursorHold", {
        buffer = bufnr,
        group = group,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "BufLeave", "InsertEnter" }, {
        buffer = bufnr,
        group = group,
        callback = vim.lsp.buf.clear_references,
      })
      vim.api.nvim_create_autocmd("LspDetach", {
        buffer = bufnr,
        group = group,
        callback = function(event)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = group, buffer = event.buf })
        end,
      })
    end
    if not disable.inlay_hints and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint ~= nil then
      -- vim.lsp.inlay_hint(bufnr, true)
      -- vim.lsp.inlay_hint.enable(bufnr, true)
      vim.lsp.inlay_hint.enable(true, { bufnr })
    end
    --[[if not disable.symbols and client.server_capabilities.documentSymbolProvider then
      local navic = require("nvim-navic")
      navic.attach(client, bufnr)
    end]]
    if not disable.signature_help and client.server_capabilities.signatureHelpProvider then
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

M.common_root_dir = function(fname)
  return require("lspconfig/util").find_git_ancestor(fname)
      or vim.fn.getcwd()
end

return M
