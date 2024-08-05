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
-------
local M = {}

M.statusline_table = function()
	return table.concat({
		"%L:%l|%c",
		"[%{mode()}]",
		" %=",
		"%{v:lua.require('config.statusline').search_message}",
		"%{v:lua.require('config.statusline').recorded_message}",
		"%{v:lua.require('config.statusline').recording_message}",
		"%{v:lua.require('config.statusline').key_memory}",
		"%= ",
		"%<",                                -- truncate
		"%{fnamemodify(expand('%'), ':.')}", -- file path inside never falls back to full path
		"%m%r%h",                            -- modified, ro, help flags
		--"%{strftime('%H:%M')}",
	})
end

function M.RedrawStatusline()
  vim.o.statusline = M.statusline_table()
end

M.laststatus_memory = vim.opt.laststatus
M.cmdheight_memory = vim.opt.cmdheight
M.statusline_else_cmdline = 1
function M.SwitchToStatusline()
  if M.statusline_else_cmdline == 0 then
    vim.opt.laststatus = M.laststatus_memory
    vim.opt.cmdheight = 0
    M.statusline_else_cmdline = 1
  end
end

function M.SwitchToCmdline()
  if M.statusline_else_cmdline == 1 then
    vim.opt.laststatus = 0
    vim.opt.cmdheight = M.cmdheight_memory
    M.statusline_else_cmdline = 0
  end
end

M.search_message = ''
-- meuter/lualine-so-fancy.nvim
function M.HandleSearch()
  -- maxcount = 0 makes the number not be capped at 99
  local search = vim.fn.searchcount({ maxcount = 0 })
  if next(search) ~= nil then
    if search.current > 0 and vim.v.hlsearch ~= 0 then
      M.search_message = '[' .. search.current .. '/' .. search.total .. ']'
      M.RedrawStatusline()
      return
    end
  end
  M.search_message = ''
end

M.recording_register = ''
M.recording_message = ''
function M.HandleRecording()
  M.recording_register = vim.fn.reg_recording()
  M.recording_message = "@" .. M.recording_register .. " < "
end

M.recorded_message = ''
function M.HandleRecordingLeave()
  local recorded_register = vim.fn.reg_recorded()
  M.recorded_message = "@" .. recorded_register .. " > " .. vim.fn.getreg(recorded_register)
  M.recording_register = ''
  M.recording_message = ''
end

M.key_memory = ''
function M.HandleKey(key)
  local b = key:byte()
  if b <= 126 and b >= 33 then
    M.key_memory = key
  else
    M.key_memory = vim.fn.keytrans(key)
  end
  if M.statusline_else_cmdline == 1 then
      M.RedrawStatusline()
  end
end

vim.on_key(M.HandleKey, M.namespace)

function M.StatuslineMonopoly()
  vim.opt.cmdheight = 0
  local group = vim.api.nvim_create_augroup("LaststatusCmdheightSwitch", { clear = true })
  vim.api.nvim_create_autocmd({ --[["ModeChanged",]] "CursorMoved" }, {
    group = group,
    callback = function()
      M.HandleSearch()
      M.RedrawStatusline()
    end,
  })
  vim.api.nvim_create_autocmd("CmdlineEnter", {
    group = group,
    callback = function()
      M.SwitchToCmdline()
    end,
  })
  vim.api.nvim_create_autocmd("CmdlineLeave", {
    group = group,
    callback = function()
      M.SwitchToStatusline()
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
      M.HandleRecordingLeave()
    end,
  })
end

-- to prevent cursorpos in left bottom corner from changing size
--[[function M.GetLinenrWidth()
  local linenr_width = vim.api.nvim_buf_line_count(0)
  if (linenr_width > 0) then
    linenr_width = math.floor(math.log10(linenr_width)) -- == width - 1
    linenr_width = linenr_width + 2 -- == linenr == width + 1
  else
    linenr_width = 0
  end
  return linenr_width
end]]

function M.Statusline()
  M.StatuslineMonopoly()
  --[[local linenr_width = GetLinenrWidth()
  vim.api.nvim_create_autocmd({ "BufEnter", "BufFilePost", "BufWritePost" }, {
    group = vim.api.nvim_create_augroup("StatuslineLineCountUpdate", { clear = true }),
    callback = function()
      linenr_width = M.GetLinenrWidth()
      vim.schedule(function()
        vim.o.statusline=M.StatuslineText({linenr_width=linenr_width})
      end)
    end,
  })]]
  M.RedrawStatusline()
  -- distinguish old timers in memory after :so by assigning a counter to them
  --[[if vim.g.statusline_ver == nil then
    vim.g.statusline_ver = 0
  elseif vim.g.statusline_ver > 10000 then
    vim.g.statusline_ver = 0
  end
  local ver = vim.g.statusline_ver + 1
  vim.g.statusline_ver = vim.g.statusline_ver + 1
  local timer = vim.loop.new_timer()
  -- for statusline update every n ms purpose
  timer:start(0, 10000, function()
    if vim.g.statusline_ver == ver then
      vim.schedule(function()
        vim.o.statusline=StatusLineText()
      end)
    else -- close when version doesn't match
      timer:close()
    end
  end)]]
end

M.Statusline()

return M
