return {
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
          --dir_icon = "",
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
    } -- To get telescope-file-browser loaded and working with telescope,
    -- you need to call load_extension, somewhere after setup function:
    require("telescope").load_extension("file_browser")
  end
}
