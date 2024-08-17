vim.opt.laststatus = 2 -- the last window will have a	status line ... 2: always

local M = {}

M.namespace = vim.api.nvim_create_namespace("core.statusline")
M.augroup = vim.api.nvim_create_augroup("core.statusline_group", { clear = true })

M.stbufnr = function()
  return vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
end

M.is_activewin = function()
  return vim.api.nvim_get_current_win() == vim.g.statusline_winid
end

M.file_info = function()
  --local project_path = vim.fn.fnamemodify(vim.fn.expand("%"), ":.")
  local project_path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(M.stbufnr()), ":.")
  if project_path == "" then return "" end
  local bufnr = M.stbufnr()
  local buf = vim.bo[bufnr]
  local help = buf.buftype == "help" and "[Help]" or ""
  local modified = not buf.modifiable and "[-]" or buf.modified and "[+]" or ""
  local readonly = buf.readonly and "[RO]" or ""
  return table.concat(
    M.list_drop_strings({
      "%<" .. project_path,
      help,
      modified,
      readonly,
    }), " ")
end

M.git_info = function()
  local buf = vim.b[M.stbufnr()]
  local head = buf.gitsigns_head
  if not head then return "" end
  local status = buf.gitsigns_status_dict
  if not status then return "" end
  local branch_name = status.head
  local added = (status.added and status.added ~= 0) and ("+" .. status.added) or ""
  local changed = (status.changed and status.changed ~= 0) and ("~" .. status.changed) or ""
  local removed = (status.removed and status.removed ~= 0) and ("-" .. status.removed) or ""
  return branch_name .. added .. changed .. removed
end

M.lsp_diagnostics = function()
  if not rawget(vim, "lsp") then return "" end
  local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
  local info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  errors = (errors and errors > 0) and ("E" .. errors) or ""
  warnings = (warnings and warnings > 0) and ("W" .. warnings) or ""
  hints = (hints and hints > 0) and ("H" .. hints) or ""
  info = (info and info > 0) and ("I" .. info) or ""
  return errors .. warnings .. hints .. info
end

M.lsp_list = function()
  if not rawget(vim, "lsp") then return "" end
  local clients = vim.lsp.get_clients()--{buffer=0})
  if vim.tbl_isempty(clients) then return '' end
  local clientnames_tbl = {}
  for _,v in pairs(clients) do
    if v.name then
      table.insert(clientnames_tbl, v.name)
    end
  end
  return table.concat(clientnames_tbl, ',')
end

M.cursor_position = function()
  local winid = vim.g.statusline_winid
  if winid == nil then return "" end
  local L = vim.fn.line("$", winid)
  local L_padded = tostring(L)
  if L < 10000 then
    local L_len = L_padded:len()
    L_padded = string.rep(" ", 5 - L_len) .. L_padded
  end
  local l = vim.fn.line(".", winid)
  local c = vim.fn.col(".", winid)
  return L_padded..":"..l.."|"..c -- "%5L:%l|%c"
end

M.search_pagination = function()
  local search = vim.fn.searchcount({ maxcount = 0 })
  if next(search) ~= nil then
    if search.current > 0 and vim.v.hlsearch ~= 0 then
      return '[' .. search.current .. '/' ..search.total .. ']'
    end
  end
  return ""
end

M.macros_recording_lambda = function()
  local recording_register = vim.fn.reg_recording()
  --local recording_content = vim.fn.getreg(recording_register)
  --vim.cmd.redrawstatus() -- is not happening unfortunately
  local recording_message = '@' .. recording_register .. '<' --.. recording_content
  return "%#StatusLineNC#" .. recording_message .. "%#StatusLine#"
end
M.macros_hidden_lambda = function() return "" end
M.macros_recorded_lambda = function()
  local recorded_register = vim.fn.reg_recorded()
  local recorded_content = vim.fn.getreg(recorded_register)
  local recorded_message = '@' .. recorded_register .. '>' .. recorded_content
  M.macros_recording = M.macros_hidden_lambda
  return "%#StatusLineNC#" .. recorded_message .. "%#StatusLine#"
end
M.macros_recording = M.macros_hidden_lambda
vim.api.nvim_create_autocmd("RecordingEnter", {
  group = M.augroup,
  callback = function()
    M.macros_recording = M.macros_recording_lambda
  end,
})
vim.api.nvim_create_autocmd("RecordingLeave", {
  group = M.augroup,
  callback = function()
    M.macros_recording = M.macros_recorded_lambda
  end,
})

----M.key_pressed_memory = ''
--function M.HandleKey(key)
--  --local b = key:byte()
--  --if b <= 126 and b >= 33 then
--  --  M.key_pressed_memory = key
--  --else
--  --  M.key_pressed_memory = vim.fn.keytrans(key)
--  --end
--  if M.recorded_visible == true then
--    M.recording_message = ''
--    M.recorded_visible = false
--  end
--end
--vim.on_key(M.HandleKey, M.namespace)

-- ###############################################

M.list_drop_strings = function(strings)
  local filtered = {}
  local index = 1
  for _, value in ipairs(strings) do
    if value ~= "" then
      filtered[index] = value
      index = index + 1
    end
  end
  return filtered
end

M.list_concat = function(strings_list)
  local strings = {}
  local index = 1
  for _, list in ipairs(strings_list) do
    strings[index] = table.concat(M.list_drop_strings(list), " ")
    index = index + 1
  end
  return table.concat(M.list_drop_strings(strings), "%=")
end

M.render_active = function()
  local statusline_left = {
    M.cursor_position()
  }
  local search_pagination = M.search_pagination()
  local macros_recording = M.macros_recording()
  local statusline_middle = nil
  if macros_recording ~= "" then
    statusline_middle = {
      macros_recording
    }
  elseif search_pagination ~= "" then
    statusline_middle = {
      search_pagination
    }
  else
    statusline_middle = {
      M.git_info(),
      M.lsp_diagnostics(),
    }
  end
  local statusline_right = {
    --M.lsp_list(),
    M.file_info(),
  }
  return M.list_concat({
    statusline_left,
    statusline_middle,
    statusline_right
  })
end

M.render_inactive = function()
  return table.concat(
    M.list_drop_strings({
      M.cursor_position(),
      "%=",
      M.file_info(),
    }), " ")
end
M.render = function()
  return M.is_activewin() and M.render_active() or M.render_inactive()
end

vim.opt.statusline = "%!v:lua.require('"..vim.g.username..".core.statusline').render()"

vim.api.nvim_create_autocmd("User", {
  group = M.augroup,
  pattern = "LspProgressUpdate",
  callback = function()
    vim.cmd.redrawstatus()
  end,
})

return M

--[[ MEMO
"%3L:%l|%c",
"%<", -- truncate
"[%{mode()}]",
"%"..params.linenr_width.."L", -- Length
"%"..params.linenr_width.."(:%l%)", -- :line
"%4(|%c%)", -- |column -- can be %3 without and %4 with a symbol in front
" %=",
"[%{mode()}]",
"%r%m",
"%= ",
"%F", -- full path
"%{getcwd()} > ", -- project directory
"%{fnamemodify(getcwd(), ':~')} > ", -- project directory relative to home
"%{@%} ", -- file path inside, falls back to full path by some reason
"%f ", -- file path inside, falls back to full path by some reason
"%m%r%h", -- modified, ro, help flags
"%<",                                -- truncate
"%{fnamemodify(expand('%'), ':.')}", -- file path inside never falls back to full
"%= ", -- separate equally 
"%P ", -- verbose position
"%bd ", -- decimal byte
"x%02B ", -- hexadecimal byte
"%{&fileencoding?&fileencoding:&encoding} ",
"%y ", -- y and Y are for filetypes
"%{strftime('%H:%M:%S')}",
"%{strftime('%H:%M')}",
]]
