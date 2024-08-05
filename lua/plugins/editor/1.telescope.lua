return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		event = "VimEnter",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			defaults = {
				color_devicons = false,
				disable_devicons = true,
				layout_config = {
					height = 100,
					width = 1000,
					horizontal = {
						prompt_position = "top",
					},
				},
				layout_strategy = "horizontal",
				sorting_strategy = "ascending",
			},
			pickers = {
				find_files = {
					hidden = true,
					["no-heading"] = true,
					["with-filename"] = true,
					["line-number"] = true,
					["column"] = true,
					["smart-case"] = true,
					disable_devicons = true,
				},
				buffers = {
					mappings = {
						i = {
							["<C-d>"] = "delete_buffer",
						},
					},
					ignore_current_buffer = true,
					sort_mru = true,
				},
			},
		},
		config = function(_, opts)
			require("telescope").setup(opts)
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
			vim.keymap.set("n", "<leader>pg", builtin.git_files, { desc = "[P]roject [G]it Files" })
			--[[vim.keymap.set('n', '<leader>/', function()
            -- You can pass additional configuration to Telescope to change the theme, layout, etc.
            builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
              winblend = 10,
              previewer = false,
            })
          end, { desc = '[/] Fuzzily search in current buffer' })]]
			--[[vim.keymap.set('n', '<leader>s/', function()
            builtin.live_grep {
              grep_open_files = true,
              prompt_title = 'Live Grep in Open Files',
            }
          end, { desc = '[S]earch [/] in Open Files' })]]
			vim.keymap.set("n", "<leader>sc", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [C]onfig" })
		end,
	},

	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
		dependencies = {
			{
				"nvim-telescope/telescope.nvim",
				opts = {
					extensions = {
						fzf = {
							fuzzy = true, -- false will only do exact matching
							override_generic_sorter = true, -- override the generic sorter
							override_file_sorter = true, -- override the file sorter
							case_mode = "smart_case", -- "smart_case" "ignore_case" "respect_case"
						},
					},
				},
			},
		},
		config = function()
			require("telescope").load_extension("fzf")
		end,
	},

	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = {
			{
				"nvim-telescope/telescope.nvim",
				opts = function(_, opts)
					local fb_actions = require("telescope._extensions.file_browser.actions")
					opts.extensions.file_browser = {
						grouped = true,
						hidden = { file_browser = false, folder_browser = false },
						respect_gitignore = vim.fn.executable("fd") == 1,
						follow_symlinks = false,
						dir_icon = "",
						--dir_icon_hl = "Default",
						--display_stat = { date = true, size = true, mode = true },
						--hijack_netrw = true,
						use_fd = true,
						git_status = true,
					}
					--[[local config = require("telescope._extensions.file_browser.config")
          opts.extensions.file_browser.mappings = {
            ["i"] = config.values.mappings.n
          }]]
					return opts
				end,
			},
		},
		config = function()
			require("telescope").load_extension("file_browser")
			vim.keymap.set("n", "<leader>ef", function()
				require("telescope").extensions.file_browser.file_browser({
					path = "%:p:h",
					select_buffer = true,
				})
			end, { desc = "[E]xplore [F]iles" })
			vim.keymap.set("n", "<leader>ep", function()
				require("telescope").extensions.file_browser.file_browser({
					path = "%:p",
				})
			end, { desc = "[E]xplore [P]roject" })
			vim.keymap.set("n", "<leader>ec", function()
				require("telescope").extensions.file_browser.file_browser({
					path = vim.fn.stdpath("config"),
				})
			end, { desc = "[E]xplore [C]onfig" })
		end,
	},
}
