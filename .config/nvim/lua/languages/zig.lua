local lsp = require("base.lsp")
lsp.configure("zls", {
  on_attach = function(client, bufnr)
    lsp.apply_indent(false, 4)
  end,
  settings = {
    zls = {
      enable_argument_placeholders = false,
    },
  },
})

return {

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "zig",
      },
    },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "zls",
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        zig = { "zig fmt" },
      },
    },
  },

}
