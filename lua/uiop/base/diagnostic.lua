local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

local diagnostic = vim.diagnostic

diagnostic.config({
  --[[virtual_text = {
    prefix = "█",--"💢",--"",
  },]]
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  signs = {
    text = {
      [diagnostic.severity.ERROR] = signs.Error,
      [diagnostic.severity.WARN] = signs.Warn,
      [diagnostic.severity.HINT] = signs.Hint,
      [diagnostic.severity.INFO] = signs.Info,
    },
  },
})

local command = vim.api.nvim_create_user_command

command("DiagnosticsOpenFloat", diagnostic.open_float, {})
command("DiagnosticsGotoPrev", diagnostic.goto_prev, {})
command("DiagnosticsGotoNext", diagnostic.goto_next, {})
command("DiagnosticsSetloclist", diagnostic.setloclist, {})

--[[
local set = vim.keymap.set
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
]]
