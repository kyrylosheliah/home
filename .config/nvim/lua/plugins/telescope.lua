return {

  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
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
          hidden = true,
          repgrep_arguments = {
            'rg',
            '--hidden',
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
      { "<leader>f", "", desc = "+find" },
    },
    config = function(_, opts)
      local layout = require("telescope.actions.layout")
      opts.defaults.mappings = {
        n = {
          [">"] = layout.cycle_layout_next,
          ["<"] = layout.cycle_layout_prev,
        },
      }
      require("telescope").setup(opts)

      local builtin = require("telescope.builtin")
      local themes = require("telescope.themes")
      vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "find files" })
      vim.keymap.set("n", "<leader>t", builtin.live_grep, { desc = "find text" })
      vim.keymap.set("n", "<leader>r", builtin.resume, { desc = "find : resume" })
      vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "find existing buffers" })
      require("base.command").add_menu_commands("find", {
        { name = "help", cmd = builtin.help_tags, description = "find help" },
        { name = "keymap", cmd = builtin.keymaps, description = "find keymaps" },
        { name = "symbols", cmd = builtin.builtin, description = "find symbols" },
        { name = "diagnostics", cmd = builtin.diagnostics, description = "find diagnostics" },
        { name = "recent files", cmd = builtin.oldfiles, description = "find recent files" },
        { name = "buffers", cmd = builtin.buffers, description = "find existing buffers" },
        { name = "git files", cmd = builtin.git_files, description = "find gitfiles" },
        {
          name = "themes",
          cmd = function()
            builtin.current_buffer_fuzzy_find(themes.get_dropdown({
              winblend = 10,
              previewer = false,
            }))
          end,
          description = "fuzzily find in current buffer",
        },
        { name = "files", cmd = builtin.find_files, description = "find files" },
        { name = "files | grep", cmd = builtin.live_grep, description = "find text" },
        { name = "resume", cmd = builtin.resume, description = "find : resume" },
        { name = "files | grep | word", cmd = builtin.grep_string, description = "find word under the cursor" },
        {
          name = "open files | grep",
          cmd = function()
            builtin.live_grep({
              grep_open_files = true,
              prompt_title = 'Live Grep in Open Files',
            })
          end,
          desc = "grep Open Files"
        },
        {
          name = "config files",
          cmd = function()
            builtin.find_files({ cwd = vim.fn.stdpath("config") })
          end,
          description = "find config",
        },
      })
    end,
  },

  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = vim.fn.has("win32") == 1
      and "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5 && cmake --build build --config Release && cmake -E copy_if_different build/Release/libfzf.dll build/libfzf.dll"
      or "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
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
      local telescope = require("telescope")
      telescope.load_extension("fzf")
    end,
  },

  {
    "Ajnasz/telescope-runcmd.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      { mode = { "n", "x" }, "<leader>;", require("base.command").open, { buffer = false }, desc = "run command" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.load_extension("runcmd")
    end,
  },

}
