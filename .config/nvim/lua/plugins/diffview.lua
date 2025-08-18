return {
  "sindrets/diffview.nvim",
  opts = {},
  config = function(_, opts)
    require("base.command").add_menu_commands("git", {
      { name = "open diff view", cmd = function() vim.cmd('DiffviewOpen') end, },
    })
  end,
}
