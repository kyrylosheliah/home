-- vim.ui.select
-- vim.ui.input
-- vim.ui.

local M = {}

M.statusline_table = table.concat({
  "%3L:%l|%c",
  --"[%{mode()}]",
  " %=",
  --"%{v:lua.require('config.statusline').key_memory}",
  "%m%r%h",
  "%= ",
  "%<",
  "%{fnamemodify(expand('%'), ':.')}",
  --"%{strftime('%H:%M')}",
})

--[[M.key_memory = ''
function M.HandleKey(key)
  local b = key:byte()
  if b <= 126 and b >= 33 then
    M.key_memory = key
  else
    M.key_memory = vim.fn.keytrans(key)
  end
  --vim.o.statusline = M.statusline_table
end
vim.on_key(M.HandleKey, M.namespace)]]

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
