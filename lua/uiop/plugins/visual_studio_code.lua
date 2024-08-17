return {
  "askfiy/visual_studio_code",
  opts = {
    --preset = false,
    --expands = {},
  },
  config = function()
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("visual_studio_code colorscheme mod", { clear = true }),
      pattern = "*",
      callback = function()
        vim.api.nvim_set_hl(0, "StatusLineNC", { link = "Directory" })
      end,
    })
    vim.cmd.colorscheme("visual_studio_code")
  end,
}
