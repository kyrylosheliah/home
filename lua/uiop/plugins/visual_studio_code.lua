return {
  "askfiy/visual_studio_code",
  opts = {
    -- `dark` or `light`
    --mode = "dark",
    -- Whether to load all color schemes
    --preset = true,
    -- Whether to enable background transparency
    transparent = true, --false,
    -- Whether to apply the adapted plugin
    --[[expands = {
      hop = true,
      dbui = true,
      lazy = true,
      aerial = true,
      null_ls = true,
      nvim_cmp = true,
      gitsigns = true,
      which_key = true,
      nvim_tree = true,
      lspconfig = true,
      telescope = true,
      bufferline = true,
      nvim_navic = true,
      nvim_notify = true,
      vim_illuminate = true,
      nvim_treesitter = true,
      nvim_ts_rainbow = true,
      nvim_scrollview = true,
      nvim_ts_rainbow2 = true,
      indent_blankline = true,
      vim_visual_multi = true,
    },
    hooks = {
      before = function(conf, colors, utils) end,
      after = function(conf, colors, utils) end,
    },]]
  },
  config = function(_, opts)
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("visual_studio_code colorscheme mod", { clear = true }),
      pattern = "*",
      callback = function()
        vim.api.nvim_set_hl(0, "StatusLine", { link = "PmenuSbar" })
        vim.api.nvim_set_hl(0, "StatusLineNC", { link = "PmenuThumb" }) --fg = "#5f5f5f", bg = "#000000" })
        vim.api.nvim_set_hl(0, "WinBar", { link = "PmenuSbar" })
        vim.api.nvim_set_hl(0, "WinBarNC", { link = "PmenuThumb" }) --fg = "#5f5f5f", bg = "#000000" })
      end,
    })
    require("visual_studio_code").setup(opts)
    vim.cmd.colorscheme("visual_studio_code")
  end,
}
