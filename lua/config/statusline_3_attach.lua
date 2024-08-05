--[[ MEMO
"%3L:%l|%c",
--"%<", -- truncate
--"[%{mode()}]",
--"%"..params.linenr_width.."L", -- Length
--"%"..params.linenr_width.."(:%l%)", -- :line
--"%4(|%c%)", -- |column -- can be %3 without and %4 with a symbol in front
" %=",
"[%{mode()}]",
"%{v:lua.require('config.statusline').key_memory}",
"%r%m",
--"%{v:lua.require('config.statusline').SearchBlock()}",
--"%{v:lua.require('config.statusline').MacroBlock()}",
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
-------------------------------
local M = {}

M.namespace = vim.api.nvim_create_namespace('config.statusline')

M.msg_show = function(...)
  local kind = select(2, ...)
  local content = select(3, ...)
--content Array of [attr_id, text_chunk]
  --[[if attr_id == 0 then
    return "Normal"
  end
nvim_buf_set_extmark]]
  --vim.log.levels.DEBUG
  --vim.log.levels.ERROR
  --vim.log.levels.INFO
  --vim.log.levels.TRACE
  --vim.log.levels.WARN
  --vim.log.levels.OFF
  local message = ""
  for i=1,#content do
    message = message..content[i][2]
  end
  local kinds_table = {
    -- echo
    [""] = vim.log.levels.OFF,--nil, -- (empty) Unknown (consider a feature-request: |bugs|)
    ["echo"] = vim.log.levels.OFF, --  |:echo| message
    ["echomsg"] = vim.log.levels.OFF, -- |:echomsg| message
    -- input related
    ["confirm"] = nil, -- |confirm()| or |:confirm| dialog
    ["confirm_sub"] = nil, -- |:substitute| confirm dialog |:s_c|
    ["return_prompt"] = nil, -- |press-enter| prompt after a multiple messages
    -- error/warnings
    ["emsg"] = vim.log.levels.ERROR, --  Error (|errors|, internal error, |:throw|, …)
    ["echoerr"] = vim.log.levels.ERROR, -- |:echoerr| message
    ["lua_error"] = vim.log.levels.ERROR, -- Error in |:lua| code
    ["rpc_error"] = vim.log.levels.ERROR, -- Error response from |rpcrequest()|
    ["wmsg"] = vim.log.levels.ERROR, --  Warning ("search hit BOTTOM", |W10|, …)
    -- hints
    ["quickfix"] = nil, -- Quickfix navigation message
    ["search_count"] = nil, -- Search count message ("S" flag of 'shortmess')
  }
  local log_level = kinds_table[kind] or vim.log.levels.OFF
  vim.notify(message, log_level)
end

M.events = {
  ["cmdline"] = nil,
  ["cmdline_show"] = nil,
  ["cmdline_hide"] = nil,
  ["cmdline_pos"] = nil,
  ["cmdline_special_char"] = nil,
  ["cmdline_block_show"] = nil,
  ["cmdline_block_append"] = nil,
  ["cmdline_block_hide"] = nil,
  ["msg_show"] = M.msg_show,
  ["msg_clear"] = nil,
  ["msg_showmode"] = nil,
  ["msg_showcmd"] = nil,
  ["msg_ruler"] = nil,
  ["msg_history_show"] = nil,
  ["msg_history_clear"] = nil,
}

local options = {
  -- Nvim will not allocate screen space for the cmdline or messages, and 'cmdheight' will be forced zero.
  -- Cmdline state is emitted as ui-cmdline events, which the UI must handle.
  --ext_cmdline = true, -- will be enabled with messages
  ext_messages = true,
}
vim.ui_attach(M.namespace, options, function(...)
  local event = select(1, ...)
  if event == nil then
    return true
  end
  local handle = M.events[event]
  if handle == nil then
    return true
  end
  vim.notify("handle")
  handle(...)
  -- check if UI update is needed
  -- after cmdline incremental updates
  --if Manager.tick() > tick then
  --  -- Util.debug(vim.inspect({ event, stack_level, Util.is_blocking(), tick, kind, ... }))
  --  if Util.is_blocking() and event ~= "msg_ruler" and kind ~= "search_count" then
  --    Util.try(Router.update)
  --  end
  --else
  --  local widget = M.parse_event(event)
  --  Util.stats.track(widget .. ".skipped")
  --end
  --stack_level = stack_level - 1
  return true
end)

M.statusline_table = table.concat({
  "%3L:%l|%c",
  "[%{mode()}]",
  " %=",
  "%{v:lua.require('config.statusline').recording_message}",
  "%{v:lua.require('config.statusline').key_memory}",
  "%= ",
  "%<",                                -- truncate
  "%{fnamemodify(expand('%'), ':.')}", -- file path inside never falls back to full path
  "%m%r%h",                            -- modified, ro, help flags
  --"%{strftime('%H:%M')}",
})

M.key_memory = ''
function M.HandleKey(key)
  local b = key:byte()
  if b <= 126 and b >= 33 then
    M.key_memory = key
  else
    M.key_memory = vim.fn.keytrans(key)
  end
  vim.o.statusline = M.statusline_table
end
vim.on_key(M.HandleKey, M.namespace)

M.recording_register = ''
M.recording_message = ''
local group = vim.api.nvim_create_augroup("RecordingTrackingGroup", { clear = true })
vim.api.nvim_create_autocmd("RecordingEnter", {
  group = group,
  callback = function()
    M.recording_register = vim.fn.reg_recording()
    M.recording_message = "@" .. M.recording_register .. " < "
    vim.o.statusline = M.statusline_table
  end,
})
vim.api.nvim_create_autocmd("RecordingLeave", {
  group = group,
  callback = function()
    M.recording_register = ''
    M.recording_message = ''
    vim.o.statusline = M.statusline_table
  end,
})

--vim.opt.cmdheight = 0
vim.o.statusline = M.statusline_table

return M
