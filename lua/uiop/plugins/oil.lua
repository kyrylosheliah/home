return {
  {
    'stevearc/oil.nvim',
    dependencies = {
      "nvim-tree/nvim-web-devicons"
    },
    opts = {
      columns = {
        --"icon",
        --"permissions",
        --"size",
        --"mtime",
      },
      git = {
        add = function(path) return true end,
        mv = function(src_path, dest_path) return true end,
        add = function(path) return true end,
      },
      win_options = {
        signcolumn = "yes:2",
      },
    },
    keys = {
      { "<leader>-", vim.cmd.Oil, mode = "n", desc = "parent (directory) (oil)" },
    },
  },
  {
    "SirZenith/oil-vcs-status",
    dependencies = {
      "stevearc/oil.nvim",
    },
    setup = function(_)
      local plugin = require("oil-vcs-status")
      local status_const = require("oil-vcs-status.constant.status")
      local StatusType = status_const.StatusType
      require("oil-vcs-status").setup({})

			vim.api.nvim_create_autocmd({ "FileType" }, {
				group = augroup("conceal_enforce"),
				pattern = {
					-- Remove conceal for oil file browser
					"oil",
				},
				callback = function()
					vim.opt_local.conceallevel = 0
				end,
			})
		end,
  },
}
