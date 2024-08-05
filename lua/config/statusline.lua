function StatusLineText()
  return table.concat(
    { "%<" -- truncate
      --, "%<%F" -- full path
      --, "%{fnamemodify(getcwd(), ':~')} > " -- directory
      , "%f " -- file path inside 
      , "%m %r %h " -- modified, ro, help flags
      , "%=" -- left/right separator
      , "%c:%l/%L " -- column:line/length
      --, "%P% " -- verbose position
      --, "%bd " -- decimal byte
      --, "x%02B " -- hexadecimal byte
      --, "%{&fileencoding?&fileencoding:&encoding} "
      --, "%{strftime('%H:%M:%S')}"
      , "%{strftime('%H:%M')}"
    })
end

function StatusLine()
  --vim.api.nvim_create_autocmd("CursorMoved", {
  --    callback = function()
  --        --vim.o.statusline="%!v:lua.StatusLineText()"
  --    end,
  --})
  vim.o.statusline="%!v:lua.StatusLineText()"
  if vim.g.statusline_ver == nil then
    vim.g.statusline_ver = 0
  elseif vim.g.statusline_ver > 10000 then
    vim.g.statusline_ver = 0
  end
  local ver = vim.g.statusline_ver + 1
  vim.g.statusline_ver = vim.g.statusline_ver + 1
  local timer = vim.loop.new_timer()
  timer:start(0, 10000, function()
    if vim.g.statusline_ver == ver then
      vim.schedule(function()
        vim.o.statusline="%!v:lua.StatusLineText()"
      end)
    else
      timer:close()
    end
  end)
end

StatusLine()
