return {

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    opts = {
      ensure_installed = {
        -- PYTHON
        "ruff",
        "debugpy",
        "black",
        "isort",
        -- RUST
        "codelldb",
        --"rustfmt", -- deprecated, install via rustup
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    --[[opts = {
      linters_by_ft = {
        --markdown = { "markdownlint" },
      },
    },]]
    config = function(_, opts)
      --require("lint").setup(opts)
      require("lint").linters_by_ft = opts.linters_by_ft or {}
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
      local lint_events = { "BufEnter", "BufReadPost", "BufWritePost", "InsertLeave" }
      local lint_augroup = vim.api.nvim_create_augroup("nvim-lint", { clear = true })
      vim.api.nvim_create_autocmd(lint_events, {
        group = lint_augroup,
        callback = debounce(1000, function()
          require("lint").try_lint()
        end),
      })
    end,
  },

}
