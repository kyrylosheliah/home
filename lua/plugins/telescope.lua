return {
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make'
  },
  {
    'nvim-telescope/telescope.nvim',
    --branch = '0.1.x',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzf-native.nvim'
    },
    config = function()
      require('telescope').setup({
        defaults = {
          color_devicons = false,
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
          }
        },
      })

      require('telescope').load_extension('fzf')
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>pg', builtin.git_files, { desc = '[P]roject [G]it Files'})
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
      vim.keymap.set('n', '<leader>sc', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [C]onfig' })
    end,
    extensions = {
      fzf = {
        fuzzy = true,                    -- false will only do exact matching
        override_generic_sorter = true,  -- override the generic sorter
        override_file_sorter = true,     -- override the file sorter
        case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      },
    },
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      vim.keymap.set("n", '<leader>ef', ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
        { desc = '[E]xplore [F]iles' })
      vim.keymap.set("n", '<leader>ep', ":Telescope file_browser path=%:p<CR>",
        { desc = '[E]xplore [P]roject' })
      vim.keymap.set('n', '<leader>ec', ":Telescope file_browser path=" .. vim.fn.stdpath('config') .. "<CR>",
        { desc = '[E]xplore [C]onfig' })
      --vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/Appdata/Local/nvim/<cr>");

      -- this is only a showcase of how you can set default options!
      --local fb_actions = require("telescope._extensions.file_browser.actions")
      require("telescope").setup {
        extensions = {
          file_browser = {
            grouped = true,
            hidden = { file_browser = false, folder_browser = false },
            respect_gitignore = vim.fn.executable("fd") == 1,
            follow_symlinks = false,
            dir_icon = "",
            --dir_icon_hl = "Default",
            --display_stat = { date = true, size = true, mode = true },
            --hijack_netrw = true, --false,
            use_fd = true,
            git_status = true,
            --[[mappings = {
            ["i"] = {
              ["<A-c>"] = fb_actions.create,
              ["<S-CR>"] = fb_actions.create_from_prompt,
              ["<A-r>"] = fb_actions.rename,
              ["<A-m>"] = fb_actions.move,
              ["<A-y>"] = fb_actions.copy,
              ["<A-d>"] = fb_actions.remove,
              ["<C-o>"] = fb_actions.open,
              ["<C-g>"] = fb_actions.goto_parent_dir,
              ["<C-e>"] = fb_actions.goto_home_dir,
              ["<C-w>"] = fb_actions.goto_cwd,
              ["<C-t>"] = fb_actions.change_cwd,
              ["<C-f>"] = fb_actions.toggle_browser,
              ["<C-h>"] = fb_actions.toggle_hidden,
              ["<C-s>"] = fb_actions.toggle_all,
              ["<bs>"] = fb_actions.backspace,
            },
            ["n"] = {
              ["c"] = fb_actions.create,
              ["r"] = fb_actions.rename,
              ["m"] = fb_actions.move,
              ["y"] = fb_actions.copy,
              ["d"] = fb_actions.remove,
              ["o"] = fb_actions.open,
              ["g"] = fb_actions.goto_parent_dir,
              ["e"] = fb_actions.goto_home_dir,
              ["w"] = fb_actions.goto_cwd,
              ["t"] = fb_actions.change_cwd,
              ["f"] = fb_actions.toggle_browser,
              ["h"] = fb_actions.toggle_hidden,
              ["s"] = fb_actions.toggle_all,
            },
          },]]
          },
        },
      }
      require("telescope").load_extension("file_browser")
    end
  },
}
