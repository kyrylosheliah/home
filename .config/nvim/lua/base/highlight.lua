local M = {}

local palette = require("base.highlight_palette")

vim.g.debug = false
vim.g.transparent = true
vim.o.background = 'dark'

M.apply_highlight = function(hl_tbl)
  for key, value in pairs(hl_tbl) do
    vim.api.nvim_set_hl(0, key, value)
  end
end

M.highlight_location = "base.highlight_table"
M.highlight_table = require(M.highlight_location)

if not vim.g.debug then

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
  M.apply_highlight(M.highlight_table)

  require("base.command").add_menu_commands("colorscheme / highlight", {
    { name = "apply default", cmd = function()
      M.apply_highlight(M.default_highlight_table)
    end, description = "Apply default highlight / colorscheme" },
  })
end

-- nvim --clean<CR>:redir file<CR>:highlightjjj<CR>:redir END<CR>
M.inspect_colors = function()
  local tbl = vim.api.nvim_get_color_map()
  for key, value in pairs(tbl) do
    tbl[key] = palette.RGB_number_to_hex(value)
  end
  print(vim.inspect(tbl))
end

M.reload = function()
  package.loaded[M.highlight_location] = nil
  M.highlight_table = require(M.highlight_location)
  M.apply_highlight(M.highlight_table)
end

M.reload()

require("base.command").add_menu_commands("colorscheme / highlight", {
  { name = "list colors", cmd = M.inspect_colors, description = "Inspect built-in colors" },
  { name = "enable reload button", cmd = function()
    vim.keymap.set("n", "<leader>`", M.reload)
  end, description = "Spawn highlight \"<leader>`\" reload button" },
  { name = "apply / reload highlight", cmd = M.reload, description = "Apply the highlight specified in `highlight_table.lua` file" },
})

return M
