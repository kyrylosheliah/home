return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      --"BurntSushi/ripgrep",
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
        borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
      },
      pickers = {
        find_files = {
          repgrep_arguments = {
            'rg',
            --'--hidden',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case'
          },
        },
        buffers = {
          mappings = {
            i = {
              ["<C-d>"] = "delete_buffer",
            },
            n = {
              ["<C-d>"] = "delete_buffer",
            },
          },
          ignore_current_buffer = true,
          sort_mru = true,
        },
      },
    },
    keys = {
      { "<leader>s", "", desc = "+search" },
      --{ "<leader>f", "", desc = "+find" },
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
      vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "... search existing buffers" })
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

  -- TODO make trouble.nvim access fuzzy-findable
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    opts = function(_, opts)
      local user_command = vim.api.nvim_create_user_command
      user_command("TroubleWorkspaceDiagnosticToggle", function()
        require("trouble").toggle()
      end, {})
      user_command("TroubleFileDiagnosticToggle", function()
        require("trouble").toggle({ filter = { buf = 0 } })
      end, {})
      user_command("TroubleQuickfixToggle", function()
        require("trouble").toggle()
      end, {})
      user_command("TroubleLoclistToggle", function()
        require("trouble").toggle(opts)
      end, {})
      user_command("TroubleTodoToggle", function()
        require("trouble").toggle(opts)
      end, {})
      return {
        focus = true,
        modes = {
          lsp = {
            win = { position = "right" },
          },
        },
      }
    end,
    --[[  keys = {
    { "<leader>xw", "<cmd>Trouble diagnostics toggle<CR>", desc = "Open trouble workspace diagnostics" },
    { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Open trouble document diagnostics" },
    { "<leader>xq", "<cmd>Trouble quickfix toggle<CR>", desc = "Open trouble quickfix list" },
    { "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Open trouble location list" },
    { "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "Open todos in trouble" },
  },]]
  },

}
