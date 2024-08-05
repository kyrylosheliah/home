vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "Normal", { bg="none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg="none" })
    vim.api.nvim_set_hl(0, "LineNr", { bg="none" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg="none" })
  end,
})

vim.cmd.colorscheme("default")
