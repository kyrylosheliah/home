vim.opt.laststatus = 2 -- the last window will have a status line ... 2: always

--vim.opt.showtabline = 2
--vim.opt.showcmdloc = "tabline"
--vim.opt.showcmdloc = "statusline"
--vim.opt.cmdheight = 0

local sysname = vim.uv.os_uname().sysname
-- vim.fn.has("win32") == 1
local is_windows = sysname == "Windows_NT"
local is_mac = sysname == "Darwin"
local is_linux = not (is_windows or is_mac)
local os_slash = is_windows and [[\]] or "/"

local M = {}

M.namespace = vim.api.nvim_create_namespace("base.status")
M.augroup = vim.api.nvim_create_augroup("base.status_group", { clear = true })

M.stbufnr = function()
  return vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
end

M.is_active_win = function()
  return vim.api.nvim_get_current_win() == vim.g.statusline_winid
end

M.mode = function()
  local mode_code = vim.api.nvim_get_mode().mode
  --local mode = mode_map[mode_code] or string.upper(mode_code)
  local mode = string.upper(mode_code)
  --return " -- " .. mode .. " -- "
  return "[" .. mode .. "]"
end

M.file_path = function()
  -- TODO: calculate all this via autocmd and not on each key press
  local bufname = vim.api.nvim_buf_get_name(M.stbufnr())
  local cwd_path = vim.fn.getcwd()
  if bufname == "" then
    --[[if is_windows then
      cwd_path = cwd_path:gsub("\\", "/")
    end]]
    return "%<" .. cwd_path
  end
  local file_path = vim.fn.fnamemodify(bufname, ":.")
  local validation = cwd_path .. os_slash .. file_path
  --[[if is_windows then
    cwd_path = cwd_path:gsub("\\", "/")
    file_path = file_path:gsub("\\", "/")
  end]]
  if is_linux then
    validation = (validation == bufname)
  else
    validation = (string.lower(validation) == string.lower(bufname))
  end
  if validation then
    file_path = (os_slash .. "." .. os_slash) .. file_path
  else
    file_path = " | " .. file_path
  end
  --return "%<" .. cwd_path .. " > " .. file_path
  return "%<" .. cwd_path .. file_path
end

M.file_info = function()
  local buf = vim.bo[M.stbufnr()]
  local help = buf.buftype == "help" and "[Help]" or ""
  local modified = not buf.modifiable and "[-]" or buf.modified and "[+]" or ""
  local readonly = buf.readonly and "[RO]" or ""
  return table.concat(
    M.list_drop_strings({
      help,
      modified,
      readonly,
    }), " ")
end

M.indentation = function()
  local spacewise = vim.opt.shiftwidth:get()
  if vim.opt.expandtab:get() then
    return "SP:" .. tostring(spacewise)
  end
  local tabwise = vim.opt.tabstop:get()
  return "TAB:" .. tostring(tabwise / spacewise)
end

M.encoding = function()
  return vim.bo.fileencoding == "" and "utf-8" or vim.bo.fileencoding
end

M.fileformat = function()
  local fileformat = vim.bo.fileformat
  --[[
  local style = {
    unix = "\\n",
    dos = "\\r\\n",
    mac = "\\r",
  }
  return fileformat .. ": " .. style[fileformat]
  ]]
  local style = {
    unix = "LF",
    dos = "CRLF",
    mac = "CR",
  }
  return style[fileformat]
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

M.diagnostics = function()
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

M.getreg = function(register)
  local content = vim.fn.getreg(register)
  content = vim.fn.keytrans(content)
  content = vim.api.nvim_replace_termcodes(content, true, true, false)
  return content
end

M.macros_recording_function = function()
  local reg = vim.fn.reg_recording()
  -- Doesn't get updated when a macro is being recorded or reset beforehand, so
  -- will show the register's old contents
  --local content = M.getreg(reg)
  return '@' .. reg .. '<'
end
M.macros_hidden_function = function() return "" end
M.macros_recorded_function = function()
  local recorded_register = vim.fn.reg_recorded()
  local recorded_content = M.getreg(recorded_register)
  local recorded_message = '@' .. recorded_register .. '>' .. recorded_content
  M.macros_recording = M.macros_hidden_function
  return recorded_message
end
M.macros_recording = M.macros_hidden_function
vim.api.nvim_create_autocmd("RecordingEnter", {
  group = M.augroup,
  callback = function()
    M.macros_recording = M.macros_recording_function
  end,
})
vim.api.nvim_create_autocmd("RecordingLeave", {
  group = M.augroup,
  callback = function()
    M.macros_recording = M.macros_recorded_function
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
  return table.concat(M.list_drop_strings(strings), "%= %=")
end

M.render_active__file = function()
  local left = {
    M.cursor_position(),
    M.mode(),
  }
  local middle = {
    M.file_info(),
  }
  local right = {
    M.file_path(),
  }
  return M.list_concat({
    left,
    middle,
    right,
  })
end

M.render_active__diagnostics = function()
  local left = {
    M.cursor_position(),
    M.mode(),
  }
  local middle = {
    M.file_info(),
  }
  local right = {
    M.git_info(),
    M.diagnostics(),
    M.lsp_list(),
  }
  return M.list_concat({
    left,
    middle,
    right
  })
end

M.render_active__format = function()
  local left = {
    M.cursor_position(),
    M.mode(),
  }
  local middle = {
    M.file_info(),
  }
  local right = {
    M.indentation(),
    M.encoding(),
    M.fileformat(),
  }
  return M.list_concat({
    left,
    middle,
    right,
  })
end

M.render_inactive = function()
  local left = {
    M.cursor_position()
  }
  local middle = {
    M.file_info()
  }
  local right = {
    M.file_path()
  }
  return M.list_concat({
    left,
    middle,
    right
  })
end

M.render_active_table = {
  M.render_active__file,
  M.render_active__diagnostics,
  M.render_active__format,
}
M.status_count = #(M.render_active_table)
M.status_mode = 1
M.render_active_handle = M.render_active_table[M.status_mode]
M.status_toggle = function()
  if M.status_mode < M.status_count then
    M.status_mode = M.status_mode + 1
  else
    M.status_mode = 1
  end
  M.render_active_handle = M.render_active_table[M.status_mode]
  vim.cmd.redrawstatus()
end

M.render_active = function()
  local macros_recording = M.macros_recording()
  if macros_recording ~= "" then
    return M.list_concat({
      { M.cursor_position(), },
      { macros_recording },
      { " ", },
    })
  end
  local search_pagination = M.search_pagination()
  if search_pagination ~= "" then
    return M.list_concat({
      { M.cursor_position(), },
      { search_pagination },
      { " ", },
    })
  end
  return M.render_active_handle()
end

M.render_statusline = function()
  return M.is_active_win() and
    M.render_active() or
    M.render_inactive()
end

vim.opt.statusline = "%!v:lua.require('base.status').render_statusline()"

--[[vim.api.nvim_create_user_command('StatusToggle', function()
  --pcall(vim.fn.)
  M.status_toggle()
end,{})]]
vim.keymap.set("n", "<leader>;", M.status_toggle, {desc="Toggle statusline content"})

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
