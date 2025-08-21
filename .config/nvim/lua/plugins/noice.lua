return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "j-hui/fidget.nvim",
    {
      "nvim-treesitter/nvim-treesitter",
      opts = {
        ensure_installed = {
          "vim",
          "regex",
          "lua",
          "bash",
          "markdown",
          "markdown_inline",
        },
      },
    },
  },
  opts = {
    cmdline = {
      view = "cmdline",
    },
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
      },
      signature = {
        enabled = false,
        auto_open = {
          enabled = false,
          trigger = false,
        },
      },
    },
    -- you can enable a preset for easier configuration
    presets = {
      --bottom_search = true, -- use a classic bottom cmdline for search
      --command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
  },
  config = function(_, opts)
    local noice = require("noice")
    noice.setup(opts)

    -- disable icons
    noice.setup({
      cmdline = {
        format = {
          cmdline = { icon = ":" },
          search_down = { icon = "/" },
          search_up = { icon = "?" },
          filter = { icon = "$" },
          lua = { icon = "lua" },
          help = { icon = "h" },
        },
      },
      format = {
        level = {
          icons = {
            error = "X",
            warn = "W",
            info = "I",
          },
        },
      },
      popupmenu = {
        kind_icons = false,
      },
    })

    -- require("base.command").add_commands({
    --   { name = "SHOW ERROR", cmd = function()
    --     vim.notify("TEST ERROR", vim.log.levels.ERROR, { title = "ERROR TITLE" })
    --   end, description = "Test out the `opt.format.level.icons` noice.nvim values" },
    --   { name = "SHOW WARN", cmd = function()
    --     vim.notify("TEST WARN", vim.log.levels.WARN, { title = "WARN TITLE" })
    --   end, description = "Test out the `opt.format.level.icons` noice.nvim values" },
    --   { name = "SHOW INFO", cmd = function()
    --     vim.notify("TEST INFO", vim.log.levels.INFO, { title = "INFO TITLE" })
    --   end, description = "Test out the `opt.format.level.icons` noice.nvim values" },
    -- })
  end,
}
