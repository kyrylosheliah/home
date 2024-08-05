--[[vim.api.nvim_create_autocmd("ColorScheme", {
 group = vim.api.nvim_create_augroup("BGTransparency", { clear = true }),
 callback = ApplyBGTransparency,
})]]

return {
  enabled = true,
  'Mofiqul/vscode.nvim',
  config = function()
    vim.o.background = 'dark'
    local c = require('vscode.colors').get_colors()
    local vscode = require('vscode')
    vscode.setup({
      --style = 'light',
      transparent = false,
      italic_comments = false,
      underline_links = false,
      disable_nvimtree_bg = false,
      group_overrides = { -- vim.api.nvim_set_hl
        Cursor = { fg=c.vscDarkBlue, bg=c.vscLightGreen, bold=true },
        Normal = {},
        NormalFloat = {},
        WinSeparator = {},
        LineNr = {},
        SignColumn = {},
        ModeMsg = {},
        MoreMsg = {},
        StatusLine = { --[[reverse=true]] },
        StatusLineNC = { link='Whitespace' },
        Directory = {},
      },
    })
    vscode.load()
    vim.cmd.colorscheme("vscode")
  end,
}
