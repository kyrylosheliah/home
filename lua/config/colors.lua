function ApplyBGTransparency()
  vim.api.nvim_set_hl(0, "ModeMsg", { cterm=NONE, ctermbg=NONE, ctermfg=NONE, gui=NONE, guibg=NONE, guifg=NONE })
  vim.api.nvim_set_hl(0, "StatusLine", { cterm=NONE, ctermbg=NONE, ctermfg=NONE, gui=NONE, guibg=NONE, guifg=NONE })
  --causes ^^^^^ symbols when StatusLine and StatusLineNC have same bg
  --vim.api.nvim_set_hl(0, "StatusLineNC", { cterm=NONE, ctermbg=NONE, ctermfg=NONE, gui=NONE, guibg=NONE, guifg=NONE })
  vim.api.nvim_set_hl(0, "TabLine", { cterm=NONE, ctermbg=NONE, ctermfg=NONE, gui=NONE, guibg=NONE, guifg=NONE })
  vim.api.nvim_set_hl(0, "TabLineSel", { cterm=NONE, ctermbg=NONE, ctermfg=NONE, gui=NONE, guibg=NONE, guifg=NONE })
  vim.api.nvim_set_hl(0, "TabLineFill", { cterm=NONE, ctermbg=NONE, ctermfg=NONE, gui=NONE, guibg=NONE, guifg=NONE })
  vim.api.nvim_set_hl(0, "Normal", { cterm=NONE, ctermbg=NONE, ctermfg=NONE, gui=NONE, guibg=NONE, guifg=NONE })
  vim.api.nvim_set_hl(0, "NormalNC", { cterm=NONE, ctermbg=NONE, ctermfg=NONE, gui=NONE, guibg=NONE, guifg=NONE })
  vim.api.nvim_set_hl(0, "NormalFloat", { cterm=NONE, ctermbg=NONE, ctermfg=NONE, gui=NONE, guibg=NONE, guifg=NONE })
  vim.api.nvim_set_hl(0, "WinBar", { cterm=NONE, ctermbg=NONE, ctermfg=NONE, gui=NONE, guibg=NONE, guifg=NONE })
  vim.api.nvim_set_hl(0, "WinBarNC", { cterm=NONE, ctermbg=NONE, ctermfg=NONE, gui=NONE, guibg=NONE, guifg=NONE })
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("BGTransparency", { clear = true }),
  callback = function()
    ApplyBGTransparency()
  end,
})
