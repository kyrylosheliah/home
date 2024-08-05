function StatusLineText()
  return table.concat(
    { "%4(%L%)%4(:%l%)%4(|%c%)", -- Length:line|column
      "%= ", -- equal separator
      "%<", -- truncate
      --"%F", -- full path
      "%{getcwd()} > ", -- project directory
      --"%{fnamemodify(getcwd(), ':~')} > ", -- project directory relative to home
      --"%{@%} ", -- file path inside, falls back to full path by some reason
      --"%f ", -- file path inside, falls back to full path by some reason
      "%{fnamemodify(expand('%'), ':.')} ", -- file path inside never falls back to full
      "%m %r %h", -- modified, ro, help flags
      "%= ", -- equal separator
      --"%P% ", -- verbose position
      --"%bd ", -- decimal byte
      --"x%02B ", -- hexadecimal byte
      --"%{&fileencoding?&fileencoding:&encoding} ",
      --"%y ", -- y and Y are for filetypes
      --"%{strftime('%H:%M:%S')}",
      "%{strftime('%H:%M')}",
    })
end

function StatusLine()
  --[[vim.api.nvim_create_autocmd("", {
    group = vim.api.nvim_create_augroup("StatuslLineUpdate", { clear = true }),
    callback = function()
      vim.schedule(function()
        vim.o.statusline="%!v:lua.StatusLineText()"
      end)
    end,
  })]]
  vim.o.statusline="%!v:lua.StatusLineText()"
  -- distinguish old timers in memory after :so by assigning a counter to them
  if vim.g.statusline_ver == nil then
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
        vim.o.statusline="%!v:lua.StatusLineText()"
      end)
    else -- close when version doesn't match
      timer:close()
    end
  end)
end

StatusLine()
