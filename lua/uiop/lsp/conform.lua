return {

  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      --[[formatters_by_ft = {
      --markdown = { "inject" }, -- makes format python codeblocks inside a markdown file
      javascript = { "prettierd", "prettier", stop_after_first = true },
      python = { "isort", "black" },
      rust = { "rustfmt" },
    }]]
      --[[local more_opts = {
      format_on_save = {
          -- These options will be passed to conform.format()
          timeout_ms = 500,
          lsp_format = "fallback",
        },
    }]]
      --opts = vim.tbl_deep_extend('force', opts, more_opts)
      vim.o.formatexpr = 'v:lua.require("conform").formatexpr()'
      return opts
    end,
  },

}
