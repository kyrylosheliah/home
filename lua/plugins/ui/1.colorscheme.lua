return {
  {
    "mcombeau/monosplash.vim",
    config = function()
      --vim.g.monosplash_color = 'green'
      vim.g.monosplash_auto_cwd_color = 1
      vim.g.monosplash_no_bg = 1
      vim.cmd.colorscheme "monosplash"
    end
  },
}
