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
-----------------------------------------------
local M = {}
M.namespace = vim.api.nvim_create_namespace('config.statusline')

M.statusline_modes = {
  default = 1,
  searching = 2,
  recording = 3,
  recorded = 4,
  message = 5,
}
M.statusline_table = {
  function() -- index 1 | default
    return table.concat({
      "%L:%l|%c",
      "[%{mode()}]",
      " %=",
      "*1*",
      "%{v:lua.require('config.statusline').message_dispatch}",
      "%{v:lua.require('config.statusline').recording_message}",
      "%{v:lua.require('config.statusline').key_memory}",
      "%= ",
      "%<",                                -- truncate
      "%{fnamemodify(expand('%'), ':.')}", -- file path inside never falls back to full path
      "%m%r%h",                            -- modified, ro, help flags
      --"%{strftime('%H:%M')}",
    })
  end,
  function() -- index 2 | searching
    return table.concat({
      "%L:%l|%c",
      " %=",
      "*2*",
      "%{v:lua.require('config.statusline').search_message}",
      "%= ",
      "%m%r%h", -- modified, ro, help flags
    })
  end,
  function() -- index 3 | recording
    return table.concat({
      "%L:%l|%c",
      "[%{mode()}]",
      " %=",
      "*3*",
      "%{v:lua.require('config.statusline').recording_message}",
      "%{v:lua.require('config.statusline').key_memory}",
      "%= ",
      "%m%r%h", -- modified, ro, help flags
    })
  end,
  function() -- index 4 | recorded
    return table.concat({
      "%L:%l|%c",
      "[%{mode()}]",
      " %=",
      "*4*",
      "%{v:lua.require('config.statusline').recorded_message}",
      "%= ",
      "%m%r%h", -- modified, ro, help flags
    })
  end,
  function() -- index 5 | message
    return table.concat({
      "%=",
      "%{v:lua.require('config.statusline').message_dispatch}",
      "%=",
    })
  end,
}

M.drawn_statusline_index = 1
function M.SetStatuslineMode(index)
  if index < 1 or index > 5 --[[#M.statusline_table]] then
    return
  end
  M.drawn_statusline_index = index
  if (index ~= M.drawn_statusline_index)
      and (M.statusline_else_cmdline == 1) then
    vim.o.statusline = M.statusline_table[index]()
  end
end

function M.RedrawStatusline()
  vim.o.statusline = M.statusline_table[M.drawn_statusline_index]()
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
    M.CheckForNewMessages()
    if M.drawn_statusline_index == M.statusline_modes.default then
      M.RedrawStatusline()
    end
  end
end

vim.on_key(M.HandleKey, M.namespace)

----------------------------------------------------------

M.TListQueue = {}
function M.TListQueue.New()
  return {
    head = nil,
    tail = nil,
    size = 0
  }
end

function M.TListQueue.PushRight(list, value)
  --local size = list.size
  local new_node = { next = nil, value = value }
  if --[[size == 0]] list.head == nil then
    list.head = new_node
  elseif --[[size == 1]] list.head.next == nil then
    list.head.next = new_node
    list.tail = new_node
  else
    list.tail.next = new_node
    list.tail = new_node
  end
  list.size = list.size + 1
end

function M.TListQueue.PopLeft(list)
  --[[
  local node = list.head
  local counter = 0
  while node ~= nil do
    counter = counter + 1
    node = node.next
  end
  print("size before pop is "..tostring(counter))
  --]]
  --local size = list.size
  if --[[list.size == 0]] list.head == nil then
    return nil
  end
  local value = list.head.value
  if --[[size == 1]] list.head.next == nil then
    list.head = nil
  elseif --[[size == 2]] list.head.next.next == nil then
    list.head = list.tail
    list.tail = nil
  else
    list.head = list.head.next
  end
  list.size = list.size - 1
  return value
end

function M.message_difference(old_table, new_table)
  --
  -- TODO a strategy to recover order by matching the pattern of old messages
  -- in new messages from the start of new messages with the start on n-th old message
  -- or from 100th in old messages
  --
  -- a strategy of checking for only 1 message
  --[[local difference_index = -1
  if #new_table ~= 0 then
    if #old_table ~= 0 then
      local last_seen_message = old_table[#old_table]
      if new_table[#new_table] ~= last_seen_message then
        difference_index = #new_table
      end
    else
      difference_index = #new_table
    end
  end
  if difference_index ~= -1 then
	  M.TListQueue.PushRight(M.message_queue, new_table[difference_index])
  end]]
  -- a strategy for potentially checking for all 200 messages cap
  local new_size = #new_table
  local old_size = #old_table
  if old_size > new_size then -- by convention
    return
  end
  local equal_size = old_size == new_size
  local difference_index = -1
  if equal_size then
    if old_size == 0 then -- the tables are both empty
      return
    end
    -- else they are equal size but maybe
    -- there is a cap of n messages and old values are shifted
    local last_seen_message = old_table[old_size]
    for i = new_size, 1, -1 do
      if new_table[i] == last_seen_message then
        difference_index = i
        break
      end
    end
  else -- not equal in size so it just catches up for it
    if old_size == 0 then
      difference_index = 1
    else
      difference_index = old_size + 1
    end
  end
  if difference_index == -1 then -- no difference
    return
  end
  for i = difference_index, new_size do
    --print(tostring(i)) -- should print first 200 indices with each consequitive cmdlineleave
    M.TListQueue.PushRight(M.message_queue, new_table[i])
  end
end

M.message_queue = M.TListQueue.New()

M.message_dispatch = ''
function M.DispatchQueuedMessage()
  local pop = M.TListQueue.PopLeft(M.message_queue)
  if pop == nil then
    M.message_dispatch = ''
  else
    M.message_dispatch = pop
  end
end

M.old_messages = {}
function M.CheckForNewMessages()
  --local new_messages = vim.api.nvim_cmd({ cmd = "messages" }, { output = true })
  local new_messages = vim.fn.execute [[messages]]
  if new_messages == "" then
    return
  end
  local lines = vim.split(new_messages, "\n")
  M.message_difference(M.old_messages, lines)
  M.old_messages = lines
end

----------------------------------------------------------

function M.StatuslineMonopoly()
  vim.opt.cmdheight = 0
  local group = vim.api.nvim_create_augroup("LaststatusCmdheightSwitch", { clear = true })
  vim.api.nvim_create_autocmd({ --[["ModeChanged",]] "CursorMoved" }, {
    group = group,
    callback = function()
      if M.message_dispatch ~= '' then
        M.DispatchQueuedMessage()
        if M.message_dispatch ~= '' then
          return
        end
      end
      M.HandleSearch()
      if (M.search_message ~= '') then
        M.SetStatuslineMode(M.statusline_modes.searching)
        return
      end
      M.SetStatuslineMode(M.statusline_modes.default)
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
      M.CheckForNewMessages()
      M.DispatchQueuedMessage()
      if M.message_dispatch ~= '' then
        M.SetStatuslineMode(M.statusline_modes.message)
      end
      M.SwitchToStatusline()
    end,
  })
  vim.api.nvim_create_autocmd("RecordingEnter", {
    group = group,
    callback = function()
      M.HandleRecording()
      M.SetStatuslineMode(M.statusline_modes.recording)
    end,
  })
  vim.api.nvim_create_autocmd("RecordingLeave", {
    group = group,
    callback = function()
      M.HandleRecordingLeave()
      M.SetStatuslineMode(M.statusline_modes.recorded)
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
