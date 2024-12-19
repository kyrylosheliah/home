return {

  {
    "mfussenegger/nvim-lint",
    dependencies = {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    --[[opts = {
      linters_by_ft = {
        --markdown = { "markdownlint" },
      },
    },]]
    opts = {
      events = {
        "BufEnter",
        --"BufReadPost",
        "BufWritePost",
        "InsertLeave",
      },
    },
    config = function(_, opts)
      local lint = require("lint")
      --require("lint").setup(opts)
      lint.linters_by_ft = opts.linters_by_ft or {}
      local debounce = function(ms, fn)
        local timer = vim.uv.new_timer()
        return function(...)
          local argv = { ... }
          timer:start(ms, 0, function()
            timer:stop()
            vim.schedule_wrap(fn)(unpack(argv))
          end)
        end
      end
      local lint_augroup = vim.api.nvim_create_augroup("nvim-lint", { clear = true })
      vim.api.nvim_create_autocmd(opts.events, {
        group = lint_augroup,
        callback = debounce(1000, function()
          lint.try_lint()
        end),
      })
    end,
  },

}
