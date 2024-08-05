return {
  enabled = false,
  'Mofiqul/vscode.nvim',
  config = function ()

    vim.o.background = 'dark'
    -- vim.o.background = 'light'

    local c = require('vscode.colors').get_colors()
    require('vscode').setup({
      -- style = 'light'
      transparent = false,
      italic_comments = false,
      underline_links = true,
      disable_nvimtree_bg = true,
      --[[color_overrides = {
        vscLineNumber = '#FFFFFF',
      },]]
      --[[group_overrides = {
        -- this supports the same val table as vim.api.nvim_set_hl
        -- use colors from this colorscheme by requiring vscode.colors!
        Cursor = { fg=c.vscDarkBlue, bg=c.vscLightGreen, bold=true },
        Normal = {},
        NormalFloat = {},
        WinSeparator = {},
        LineNr = {},
        SignColumn = {},
        ModeMsg = {},
        MoreMsg = {},
        StatusLine = {}, --reverse=true
        StatusLineNC = { link="Whitespace" },
        Directory = {},
      }]]
    })
    vim.cmd.colorscheme "vscode"
  end
}
