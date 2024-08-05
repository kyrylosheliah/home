function ApplyBGTransparency()
  local reset = {
    --cterm=NONE,
    --gui=NONE,
    --guibg=NONE,
    --guifg=NONE
  }
  local hl = vim.api.nvim_set_hl
  hl(0, 'Normal', reset)
  hl(0, 'NormalFloat', reset)
  hl(0, 'WinSeparator', reset)
  hl(0, 'LineNr', reset)
  hl(0, 'ModeMsg', reset)
  hl(0, 'MoreMsg', reset)
  hl(0, 'StatusLine', reset)
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("BGTransparency", { clear = true }),
  callback = ApplyBGTransparency,
})

return {
  enabled = true,
  'Mofiqul/vscode.nvim',
  config = function()
    -- For dark theme (neovim's default)
    vim.o.background = 'dark'
    local c = require('vscode.colors').get_colors()
    local vscode = require('vscode')
    vscode.setup({
      -- Alternatively set style in setup
      -- style = 'light'

      -- Enable transparent background
      transparent = false,

      -- Enable italic comment
      italic_comments = false,

      -- Underline `@markup.link.*` variants
      underline_links = false,

      -- Disable nvim-tree background color
      disable_nvimtree_bg = false,

      -- Override colors (see ./lua/vscode/colors.lua)
      --color_overrides = {
      --    vscLineNumber = '#FFFFFF',
      --},

      -- Override highlight groups (see ./lua/vscode/theme.lua)
      --group_overrides = {
      --  -- this supports the same val table as vim.api.nvim_set_hl
      --  -- use colors from this colorscheme by requiring vscode.colors!
      --  Cursor = { fg=c.vscDarkBlue, bg=c.vscLightGreen, bold=true },
      --}
    })
    vscode.load()
    vim.cmd.colorscheme("vscode")
  end,
}
