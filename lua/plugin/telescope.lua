local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set('n', '<leader>pg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>po', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>pb', builtin.buffers, {})
vim.keymap.set('n', '<leader>ph', builtin.help_tags, {})

require('telescope').setup({
  defaults = {
    color_devicons = false,
    layout_config = {
      height = 100,
      width = 1000,
    },
  },
  pickers = {
    find_files = {
      hidden = true,
      ["no-heading"] = true,
      ["with-filename"] = true,
      ["line-number"] = true,
      ["column"] = true,
      ["smart-case"] = true,
    },
    buffers = {
      mappings = {
        i = {
          ["<C-d>"] = "delete_buffer",
        },
      },
      --ignore_current_buffer = true,
      sort_mru = true,
    }
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    }
  },
})

require("telescope").load_extension("lazygit")
require('telescope').load_extension('fzf')
