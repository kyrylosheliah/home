local M = {}

M.apply_highlight = function(hl_tbl)
  for key, value in pairs(hl_tbl) do
    vim.api.nvim_set_hl(0, key, value)
  end
end
M.extract_highlight = function()
  local tbl = {}
  --local entries_to_hex_parse = { "fg", "bg", "sp", "blend", }
  --local entries_to_parse_termcolor = { "ctermbg", "ctermfg", }
  for key, _ in pairs(M.highlight_table) do
    tbl[key] = vim.api.nvim_get_hl(0, { name = key })
  end
  return tbl
end

M.highlight_location = vim.g.username .. ".core.highlight_table"
M.highlight_table = require(M.highlight_location)
vim.keymap.set("n", "<leader>`", function()
  package.loaded[M.highlight_location] = nil
  M.highlight_table = require(M.highlight_location)
  M.apply_highlight(M.highlight_table)
end)
M.default_highlight_table = M.extract_highlight()
vim.keymap.set("n", "<leader>~", function()
  M.apply_highlight(M.default_highlight_table)
end)
vim.keymap.set("n", "<leader>~~", function()
  local tbl = vim.api.nvim_get_color_map()
  --local tbl = vim.inspect(M.extract_highlight())
  for key, num in pairs(tbl) do
    local check = {
      b = string.format("%x", (bit.band(num, tonumber("0xFF")))),
      g = string.format("%x", (bit.rshift(bit.band(num, tonumber("0xFF00")), 8))),
      r = string.format("%x", (bit.rshift(bit.band(num, tonumber("0xFF0000")), 16))),
      --a = string.format("%x", ((bit.rshift(bit.band(num, tonumber("0xFF000000")), 24 ) / 255 ))),
    }
    for ckey, value in pairs(check) do
      while #(check[ckey]) < 2 do
        check[ckey] = "0" .. value
      end
    end
    tbl[key] = '#' .. check.r .. check.g .. check.b --.. check.a
  end
  print(vim.inspect(tbl))
end)

--[[vim.api.nvim_create_user_command('InspectHighlightGroup', function (opts)
  local args = opts['args']
  if args then
    local hl = vim.api.nvim_get_hl(0, { name = args })
    if hl ~= nil then
      vim.print(vim.inspect(hl))
    end
  end
end, { desc = "Inspect Highlight Group (by group name)", nargs = 1 })]]

-- colorscheme transparancy
--[[M.apply_transparency = function()
  vim.api.nvim_set_hl(0, "Normal", { bg="none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg="none" })
  vim.api.nvim_set_hl(0, "LineNr", { bg="none" })
  vim.api.nvim_set_hl(0, "SignColumn", { bg="none" })
end
M.apply_transparency()
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("core.colorscheme", { clear = true }),
  pattern = "*",
  callback = M.apply_transparency,
})]]

return M
