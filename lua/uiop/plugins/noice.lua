return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "j-hui/fidget.nvim",
  },
  keys = {
    { "<leader>c", "", desc = "+commandline" },
    --{
    --  "<S-Enter>",
    --  function()
    --    require("noice").redirect(vim.fn.getcmdline())
    --  end,
    --  mode = "c",
    --  desc = "Redirect Cmdline",
    --},
    {
      "<leader>cl",
      function() require("noice").cmd("last") end,
      desc = "commandline last ... message",
    },
    {
      "<leader>ch",
      function() require("noice").cmd("history") end,
      desc = "commandline history",
    },
    {
      "<leader>ca",
      function() require("noice").cmd("all") end,
      desc = "commandline all",
    },
    {
      "<leader>cd",
      function() require("noice").cmd("dismiss") end,
      desc = "commandline dismiss ... all",
    },
    {
      "<leader>cs",
      function() require("noice").cmd("pick") end,
      desc = "commandline search"
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
    },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
  },
}
