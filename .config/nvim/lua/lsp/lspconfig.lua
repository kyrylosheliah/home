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
  end,
}

--    vim.api.nvim_create_autocmd('LspAttach', {
--      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
--      callback = function(event)
--        local map = function(keys, func, desc, mode)
--          mode = mode or 'n'
--          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
--        end
--        -- Rename the variable under your cursor.
--        map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
--        -- Execute a code action, usually your cursor needs to be on top of an error
--        -- or a suggestion from your LSP for this to activate.
--        map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
--        -- Find references for the word under your cursor.
--        map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
--        -- Jump to the implementation of the word under your cursor.
--        --  Useful when your language has ways of declaring types without an actual implementation.
--        map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
--        -- Jump to the definition of the word under your cursor.
--        --  This is where a variable was first declared, or where a function is defined, etc.
--        --  To jump back, press <C-t>.
--        map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
--        -- WARN: This is not Goto Definition, this is Goto Declaration.
--        --  For example, in C this would take you to the header.
--        map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
--        -- Fuzzy find all the symbols in your current document.
--        --  Symbols are things like variables, functions, types, etc.
--        map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
--        -- Fuzzy find all the symbols in your current workspace.
--        --  Similar to document symbols, except searches over your entire project.
--        map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
--        -- Jump to the type of the word under your cursor.
--        --  Useful when you're not sure what type a variable is and you want to see
--        --  the definition of its *type*, not where it was *defined*.
--        map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
--
--        -- The following two autocommands are used to highlight references of the
--        -- The following code creates a keymap to toggle inlay hints in your
--        -- code, if the language server you are using supports them
--        --
--        -- This may be unwanted, since they displace some of your code
--        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
--          map('<leader>th', function()
--            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
--          end, '[T]oggle Inlay [H]ints')
--        end
--      end,
--    })
--
--local apply_default_keymaps = function(event)
--  local bufnr = event.buf
--  local command = vim.api.nvim_buf_create_user_command
--  --vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", { buffer = bufnr, silent = true, desc = "Show buffer diagnostics" })
--  --vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", { buffer = bufnr, silent = true, desc = "Show line diagnostics" })
--  vim.keymap.set("n", "gd",
--    vim.lsp.buf.definition,
--    { noremap = true, silent = true, buffer = bufnr, desc = "LspDefinition" })
--  vim.keymap.set("n", "gD",
--    vim.lsp.buf.declaration,
--    { noremap = true, silent = true, buffer = bufnr, desc = "LspDeclaration" })
--  vim.keymap.set("n", "gt",
--    vim.lsp.buf.type_definition,
--    { noremap = true, silent = true, buffer = bufnr, desc = "LspTypeDefinition" })
--  vim.keymap.set("n", "gr",
--    vim.lsp.buf.references,
--    { noremap = true, silent = true, buffer = bufnr, desc = "LspReferences" })
--  vim.keymap.set("n", "gi",
--    vim.lsp.buf.implementation,
--    { noremap = true, silent = true, buffer = bufnr, desc = "LspImplementation" })
--  vim.keymap.set("n", "ge",
--    vim.lsp.buf.rename,
--    { noremap = true, silent = true, buffer = bufnr, desc = "LspRename" })
--  vim.keymap.set({ "n", "x" }, "gf", function()
--    vim.lsp.buf.format({ --[[bufnr = bufnr,]] async = true })
--  end, { noremap = true, silent = true, buffer = bufnr, desc = "LspFormat" })
--  --[[vim.keymap.set("x", "g;", function()
--    local start_row, _ = unpack(vim.api.nvim_buf_get_mark(0, "<"))
--    local end_row, _ = unpack(vim.api.nvim_buf_get_mark(0, ">"))
--    vim.lsp.buf.format({
--      range = {
--        ["start"] = { start_row, 0 },
--        ["end"] = { end_row, 0 },
--      },
--      async = true,
--      bufnr = bufnr,
--    })
--    end, { noremap = true, silent = true, buffer = bufnr, desc = "LspFormatRange" })]]
--  vim.keymap.set("n", "ga",
--    vim.lsp.buf.code_action,
--    { noremap = true, silent = true, buffer = bufnr, desc = "LspCodeAction" })
--  vim.keymap.set("n", "gs",
--    vim.lsp.buf.signature_help,
--    { noremap = true, silent = true, buffer = bufnr, desc = "LspSignatureHelp" })
--  vim.keymap.set("n", "gL",
--    vim.lsp.codelens.refresh,
--    { noremap = true, silent = true, buffer = bufnr, desc = "LspCodeLensRefresh" })
--  vim.keymap.set("n", "gl",
--    vim.lsp.codelens.run,
--    { noremap = true, silent = true, buffer = bufnr, desc = "LspCodeLensRun" })
--  vim.keymap.set("n", "gh",
--    vim.lsp.buf.hover,
--    { noremap = true, silent = true, buffer = bufnr, desc = "LspHover" })
--  vim.keymap.set("n", "K",
--    vim.lsp.buf.hover,
--    { noremap = true, silent = true, buffer = bufnr, desc = "LspHover" })
--  command(bufnr, "LspDocumentSymbol", vim.lsp.buf.document_symbol, {})
--  command(bufnr, "LspWorkspaceSymbol", vim.lsp.buf.workspace_symbol, {})
--  command(bufnr, "LspAddToWorkspaceFolder", vim.lsp.buf.add_workspace_folder, {})
--  command(bufnr, "LspRemoveWorkspaceFolder", vim.lsp.buf.remove_workspace_folder, {})
--  command(bufnr, "LspListWorkspaceFolders", vim.lsp.buf.list_workspace_folders, {})
--  command(bufnr, "LspIncomingCalls", vim.lsp.buf.incoming_calls, {})
--  command(bufnr, "LspOutgoingCalls", vim.lsp.buf.outgoing_calls, {})
--  -- ===========
--  -- DIAGNOSTICS
--  -- ===========
--  local goto_prev = function(severity)
--    return function()
--      vim.diagnostic.goto_prev({
--        severity = severity and vim.diagnostic.severity[severity] or nil
--      })
--    end
--  end
--  local goto_next = function(severity)
--    return function()
--      vim.diagnostic.goto_next({
--        severity = severity and vim.diagnostic.severity[severity] or nil
--      })
--    end
--  end
--  vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { buffer = bufnr, desc = "Line Diagnostics" })
--  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr, desc = "Next Diagnostic" })
--  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "Prev Diagnostic" })
--  vim.keymap.set("n", "]e", goto_next("ERROR"), { buffer = bufnr, desc = "Next Error" })
--  vim.keymap.set("n", "[e", goto_prev("ERROR"), { buffer = bufnr, desc = "Prev Error" })
--  vim.keymap.set("n", "]w", goto_next("WARN"), { buffer = bufnr, desc = "Next Warning" })
--  vim.keymap.set("n", "[w", goto_prev("WARN"), { buffer = bufnr, desc = "Prev Warning" })
--  command(bufnr, "DiagnosticsSetloclist", vim.diagnostic.setloclist, {})
--  command(bufnr, "DiagnosticsQuickfixlist", vim.diagnostic.setqflist, {})
--  vim.keymap.set("n", "<leader>th", function()
--    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr }))
--  end, { buffer = bufnr, desc = "Toggle Inlay Hints" })
--end
