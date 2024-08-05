local M = {}
M.namespace = vim.api.nvim_create_namespace('config.statusline')

M.statusline_active = function()
  return table.concat({
  "%5L:%l|%c",
  "%=",
  --"%{v:lua.require('config.statusline').key_memory}",
  "%<",
  "[%{fnamemodify(expand('%'), ':.')}]",
  "%m%r%h",
  --"%=",
  --"[%{mode()}]",
  --"%{v:lua.require('config.statusline').search_pagination}",
  --"%{v:lua.require('config.statusline').recording_message}",
  --" %{strftime('%H:%M')}",
})
end

M.statusline_inactive = function()
  return table.concat({
    "%=",
    "%<",
    "[%{fnamemodify(expand('%'), ':.')}]",
    "%=",
  })
end

M.lsp_message = ""
M.lsp = function()
  local count = {}
  local levels = {
    errors = "Error",
    warnings = "Warn",
    info = "Info",
    hints = "Hint",
  }

  for k, level in pairs(levels) do
    count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
  end

  local errors = ""
  local warnings = ""
  local hints = ""
  local info = ""

  if count["errors"] ~= 0 then
    errors = " %#LspDiagnosticsSignError# " .. count["errors"]
  end
  if count["warnings"] ~= 0 then
    warnings = " %#LspDiagnosticsSignWarning# " .. count["warnings"]
  end
  if count["hints"] ~= 0 then
    hints = " %#LspDiagnosticsSignHint# " .. count["hints"]
  end
  if count["info"] ~= 0 then
    info = " %#LspDiagnosticsSignInformation# " .. count["info"]
  end

  return errors .. warnings .. hints .. info .. "%#Normal#"
end

M.gitsigns_message = ""
M.gitsigns = function()
  local git_info = vim.b.gitsigns_status_dict
  if not git_info or git_info.head == "" then
    return ""
  end
  local added = git_info.added and ("%#GitSignsAdd#+" .. git_info.added .. " ") or ""
  local changed = git_info.changed and ("%#GitSignsChange#~" .. git_info.changed .. " ") or ""
  local removed = git_info.removed and ("%#GitSignsDelete#-" .. git_info.removed .. " ") or ""
  if git_info.added == 0 then
    added = ""
  end
  if git_info.changed == 0 then
    changed = ""
  end
  if git_info.removed == 0 then
    removed = ""
  end
  return table.concat {
     " ",
     added,
     changed,
     removed,
     " ",
     "%#GitSignsAdd# ",
     git_info.head,
     " %#Normal#",
  }
end

M.search_pagination = ''
function M.HandleSearch()
  local search = vim.fn.searchcount({ maxcount = 0 })
  if next(search) ~= nil then
    if search.current > 0 and vim.v.hlsearch ~= 0 then
      M.search_pagination = '[' .. search.current .. '/' ..search.total .. ']'
      return
    end
  end
  M.search_pagination = ''
end

M.recording_message = ''
function M.HandleRecording()
  M.recording_register = vim.fn.reg_recording()
  M.recording_message = '@' .. M.recording_register .. '<'
end

M.recorded_visible = false
function M.HandleRecorded()
  --local recorded_register = vim.fn.reg_recorded()
  M.recording_message = '@' .. M.recording_register .. '>' .. vim.fn.getreg(M.recording_register)
  M.recorded_visible = true
end

M.key_memory = ''
function M.HandleKey(key)
  local b = key:byte()
  if b <= 126 and b >= 33 then
    M.key_memory = key
  else
    M.key_memory = vim.fn.keytrans(key)
  end
  if M.recorded_visible == true then
    M.recording_message = ''
    M.recorded_visible = false
  end
end
vim.on_key(M.HandleKey, M.namespace)

local group = vim.api.nvim_create_augroup("config.statusline", { clear = true })

vim.api.nvim_create_autocmd({ --[["ModeChanged",]] "CursorMoved" }, {
  group = group,
  callback = function()
    M.HandleSearch()
  end,
})
vim.api.nvim_create_autocmd("RecordingEnter", {
  group = group,
  callback = function()
    M.HandleRecording()
  end,
})
vim.api.nvim_create_autocmd("RecordingLeave", {
  group = group,
  callback = function()
    M.HandleRecorded()
  end,
})

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  group = group,
  callback = function()
    vim.o.statusline = M.statusline_active()
  end,
})
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  group = group,
  callback = function()
    vim.o.statusline = M.statusline_inactive()
  end,
})

vim.o.statusline = M.statusline_active()

return M

--[[ MEMO
"%3L:%l|%c",
--"%<", -- truncate
--"[%{mode()}]",
--"%"..params.linenr_width.."L", -- Length
--"%"..params.linenr_width.."(:%l%)", -- :line
--"%4(|%c%)", -- |column -- can be %3 without and %4 with a symbol in front
" %=",
"[%{mode()}]",
"%r%m",
"%= ",
--"%F", -- full path
--"%{getcwd()} > ", -- project directory
--"%{fnamemodify(getcwd(), ':~')} > ", -- project directory relative to home
--"%{@%} ", -- file path inside, falls back to full path by some reason
--"%f ", -- file path inside, falls back to full path by some reason
--"%m%r%h", -- modified, ro, help flags
"%<",                                -- truncate
"%{fnamemodify(expand('%'), ':.')}", -- file path inside never falls back to full
--"%= ", -- equal separator
--"%P ", -- verbose position
--"%bd ", -- decimal byte
--"x%02B ", -- hexadecimal byte
--"%{&fileencoding?&fileencoding:&encoding} ",
--"%y ", -- y and Y are for filetypes
--"%{strftime('%H:%M:%S')}",
--"%{strftime('%H:%M')}",
]]
-----------------------------------------------

