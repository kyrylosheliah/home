local M = {}

--[[M.apply_colorscheme_hl = function(hl_tbl)
  for key, value in pairs(hl_tbl) do
    vim.api.nvim_set_hl(0, key, value)
  end
end
M.colorscheme_location = vim.g.username .. ".core.colorscheme-config"
vim.keymap.set("n", "<leader>`", function()
  package.loaded[M.colorscheme_location] = nil
  local colorscheme = require(M.colorscheme_location)
  M.apply_colorscheme_hl(colorscheme)
end)]]

--[[M.default_hl = {}
M.extract_default_hl = function()
  local colorscheme = require(M.colorscheme_location)
  for key, _ in pairs(colorscheme) do
    M.default_hl[key] = vim.api.nvim_get_hl(0, { name = key })
  end
end
M.extract_default_hl()
vim.keymap.set("n", "<leader>~", function()
  M.apply_colorscheme_hl(M.default_hl)
end)]]

--[[vim.api.nvim_create_user_command('IHL', function (opts)
  local args = opts['args']
  if args then
    local hl = vim.api.nvim_get_hl(0, { name = args })
    if hl ~= nil then
      vim.print(vim.inspect(hl))
    end
  end
end, { desc = "[I]nspect [H]igh[L]ight Group (by name)", nargs = 1 })]]

-- Transparancy
M.apply_transparency = function()
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
})

return M
