-- thanks to "mellow-theme/mellow.nvim" and "datsfilipe/nvim-colorscheme-template"

vim.g.debug = true
vim.g.transparent = false
--vim.g.highlight_table_name = "visual_studio"
vim.g.highlight_table_name = "custom"
--vim.g.highlight_table_name = "mix"
vim.o.background = 'dark'

local M = {}

M.apply_highlight = function(hl_tbl)
  for key, value in pairs(hl_tbl) do
    vim.api.nvim_set_hl(0, key, value)
  end
end

M.highlight_location = vim.g.username .. ".base.highlight_table_" .. vim.g.highlight_table_name
M.highlight_table = require(M.highlight_location)
M.reload = function()
  package.loaded[M.highlight_location] = nil
  M.highlight_table = require(M.highlight_location)
  M.apply_highlight(M.highlight_table)
end

if not vim.g.debug then
  M.reload()
else
  vim.keymap.set("n", "<leader>`", M.reload)
  M.extract_highlight = function()
    local tbl = {}
    --local entries_to_hex_parse = { "fg", "bg", "sp", "blend", }
    --local entries_to_parse_termcolor = { "ctermbg", "ctermfg", }
    for key, _ in pairs(M.highlight_table) do
      tbl[key] = vim.api.nvim_get_hl(0, { name = key })
    end
    return tbl
  end
  M.default_highlight_table = M.extract_highlight()
  vim.keymap.set("n", "<leader>~", function()
    M.apply_highlight(M.default_highlight_table)
  end)
  M.apply_highlight(M.highlight_table)
  M.inspect_colors = function()
    local RGB_number_to_hex = function(value)
      local b = string.format("%x", (bit.band(value, tonumber("0xFF"))))
      local g = string.format("%x", (bit.rshift(bit.band(value, tonumber("0xFF00")), 8)))
      local r = string.format("%x", (bit.rshift(bit.band(value, tonumber("0xFF0000")), 16)))
      while #(r) < 2 do
        r = "0" .. r
      end
      while #(g) < 2 do
        g = "0" .. g
      end
      while #(b) < 2 do
        b = "0" .. b
      end
      return '#' .. r .. g .. b
    end
    local tbl = vim.api.nvim_get_color_map()
    for key, value in pairs(tbl) do
      tbl[key] = RGB_number_to_hex(value)
    end
    print(vim.inspect(tbl))
  end
end

return M
