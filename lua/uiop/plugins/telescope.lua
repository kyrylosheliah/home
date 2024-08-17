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
          width = function(_, cols, _) return cols end,
          height = function(_, _, rows) return rows end,
          prompt_position = "top",
          mirror = true,
          preview_cutoff = 1,
        },
        layout_strategy = "vertical",
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
            n = {
              ["d"] = "delete_buffer",
            },
          },
          ignore_current_buffer = true,
          sort_mru = true,
        },
      },
    },
    keys = {
      { "<leader>s", "", desc = "+search" },
      { "<leader>f", "", desc = "+find" },
    },
    config = function(_, opts)
      local layout = require("telescope.actions.layout")
      opts.defaults.mappings = {
        --[[i = {
          ["<C-[>"] = layout.cycle_layout_prev,
          ["<C-]>"] = layout.cycle_layout_next,
        },]]
        n = {
          [">"] = layout.cycle_layout_next,
          ["<"] = layout.cycle_layout_prev,
        },
      }
      require("telescope").setup(opts)

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "search help" })
      vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "search keymaps" })
      vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "search files" })
      vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "search symbols" })
      vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "search word ... under the cursor" })
      vim.keymap.set("n", "<leader>st", builtin.live_grep, { desc = "search text" })
      vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "search diagnostics" })
      vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "search: resume" })
      vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = 'search ... recent files' })
      vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "... search existing buffers" })
      vim.keymap.set("n", "<leader>sg", builtin.git_files, { desc = "search git ... files" })
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
          end, { desc = 'search [/] in Open Files' })]]
      vim.keymap.set("n", "<leader>sc", function()
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "search config" })
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

}
