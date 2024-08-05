return {

	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			--[[vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function(args)
          require("conform").format({ bufnr = args.buf })
        end,
      })]]
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
			return {
				formatters_by_ft = {
					--[[lua = { "stylua" },
          -- Conform will run multiple formatters sequentially
          python = { "isort", "black" },
          -- Conform will run the first available formatter
          javascript = { "prettierd", "prettier", stop_after_first = true },]]
				},
				--[[format_on_save = {
          -- These options will be passed to conform.format()
          timeout_ms = 500,
          lsp_format = "fallback",
        },]]
			}
		end,
	},
}
