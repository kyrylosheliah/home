-- vim.ui.select
-- vim.ui.input
-- vim.ui.

local M = {}

M.namespace = vim.api.nvim_create_namespace('config.statusline')

M.laststatus_memory = vim.opt.laststatus
M.cmdheight_memory = vim.opt.cmdheight
M.cmdline_table = ''
M.cmdline_else_statusline = false
M.SetStatusline = function()
  if M.cmdline_else_statusline then
    M.cmdline_else_statusline = false
    vim.opt.laststatus = M.laststatus_memory
    vim.opt.cmdheight = 0
    vim.o.statusline = M.statusline_table
  end
end
M.RefreshStatusline = function()
  vim.o.statusline = M.statusline_table
end
M.SetCmdline = function()
  if not M.cmdline_else_statusline then
    M.cmdline_else_statusline = true
    vim.opt.laststatus = 0
    vim.opt.cmdheight = M.cmdheight_memory
    vim.opt.statusline = M.cmdline_table
  end
end
M.RefreshCommandline = function()
  vim.o.statusline = M.cmdline_table
end

--Triggered when the cmdline is displayed or changed.
M.cmdline_show = function(event, content, pos, firstc, prompt, indent, level)
  print('cmdline_show')
  --content: List of [attrs, string] [[{}, "t"], [attrs, "est"], ...]
  --  The content is the full content that should be displayed in the cmdline,
  --The pos is the position of the cursor that in the cmdline.
  --  The content is divided into chunks with different highlight attributes
  --  represented as a dict (see ui-event-highlight_set).
  --firstc and prompt are text, that if non-empty should be displayed in front
  --  of the command line. firstc always indicates built-in command lines such
  --  as : (ex command) and / ? (search), while prompt is an input() prompt.
  --indent tells how many spaces the content should be indented.
  --The Nvim command line can be invoked recursively, for instance by typing
  --  <c-r>= at the command line prompt. The level field is used to
  --  distinguish different command lines active at the same time. The first
  --  invoked command line has level 1, the next recursively-invoked prompt
  --  has level 2. A command line invoked from the cmdline-window has a
  --  higher level than the edited command line.
  M.SetCmdline()
  print(tostring(pos))
end

--Change the cursor position in the cmdline.
M.cmdline_pos = function(event, pos, level)
  vim.notify('cmdline_pos')
end

--Display a special char in the cmdline at the cursor position. This is typically used to indicate a pending state, e.g. after c_CTRL-V. If shift is true the text after the cursor should be shifted, otherwise it should overwrite the char at the cursor.
--Should be hidden at next cmdline_show.
M.cmdline_special_char = function(event, c, shift, level)
  vim.notify('cmdline_special_char')
end

--Hide the cmdline.
M.cmdline_hide = function(event)
  vim.notify('cmdline_hide')
  M.SetStatusline()
end

--Show a block of context to the current command line. For example if
--the user defines a :function interactively: function Foo() echo "foo" end
M.cmdline_block_show = function(event, lines)
  vim.notify('cmdline_block_show')
--lines is a list of lines of highlighted chunks, in the same form as the "cmdline_show" contents parameter.
end

--Append a line at the end of the currently shown block.
M.cmdline_block_append = function(event, line)
  vim.notify('cmdline_block_append')
end

--Hide the block.
M.cmdline_block_hide = function(event)
  vim.notify('cmdline_block_hide')
end

--vim.opt.cmdheight = 0
--[[local options = {
  -- This UI extension delegates presentation of the cmdline (except 'wildmenu').
  ext_cmdline = true
}
vim.ui_attach(M.namespace, options, function(event, ...)
  local route = M[event]
  if route ~= nil then
    vim.notify(event)
    route(event, unpack(...))
  else
    vim.notify(event..' is nil')
  end
end)]]

M.statusline_table = table.concat({
  "%5L:%l|%c",
  --"[%{mode()}]",
  " %=",
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
  --vim.o.statusline = M.statusline_table
end
vim.on_key(M.HandleKey, M.namespace)

vim.o.statusline = M.statusline_table

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
