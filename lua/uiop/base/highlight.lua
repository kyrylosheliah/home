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

-- colorscheme transparancy
--[[M.apply_transparency = function()
  vim.api.nvim_set_hl(0, "Normal", { bg="none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg="none" })
  vim.api.nvim_set_hl(0, "LineNr", { bg="none" })
  vim.api.nvim_set_hl(0, "SignColumn", { bg="none" })
end
M.apply_transparency()
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("base.highlight", { clear = true }),
  pattern = "*",
  callback = M.apply_transparency,
})]]

return M
