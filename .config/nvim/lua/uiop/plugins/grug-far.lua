return {

  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    keys = {
      { "<leader>r", "", desc = "+replace" },
      {
        "<leader>rp",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.grug_far({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "replace project-wide",
      },
    },
    opts = { headerMaxWidth = 80 },
  },

}
