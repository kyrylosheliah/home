local debug = true

local M = {}

M.apply_highlight = function(hl_tbl)
  for key, value in pairs(hl_tbl) do
    vim.api.nvim_set_hl(0, key, value)
  end
end

M.highlight_location = vim.g.username .. ".base.highlight_table"
M.highlight_table = require(M.highlight_location)

if not debug then
  M.apply_highlight(M.highlight_table)
else
  vim.keymap.set("n", "<leader>`", function()
    package.loaded[M.highlight_location] = nil
    M.highlight_table = require(M.highlight_location)
    M.apply_highlight(M.highlight_table)
  end)
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
end

return M

-- thanks to "mellow-theme/mellow.nvim" and "datsfilipe/nvim-colorscheme-template"
