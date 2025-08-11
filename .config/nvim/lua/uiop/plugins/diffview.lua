return {
  "sindrets/diffview.nvim",
  opts = function()
    vim.g.add_commands({
      { name = "open diff view", cmd = function() vim.cmd('DiffviewOpen') end, },
    })
    return {}
  end,
}
