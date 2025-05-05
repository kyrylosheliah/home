return {

  {
    "stevearc/conform.nvim",
    opts = {},
    --[[formatters_by_ft = {
      --markdown = { "inject" }, -- makes format python codeblocks inside a markdown file
      javascript = { "prettierd", "prettier", stop_after_first = true },
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    }]]
    config = function(_, opts)
      require("conform").setup(opts)
      vim.api.nvim_set_option_value("formatexpr", 'v:lua.require("conform").formatexpr()', {})
    end,
  },

}
