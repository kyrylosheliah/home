return {

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        icons_enabled = false,
        theme = 'auto',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 10000,
          tabline = 1000,
          winbar = 1000,
        }
      },
      sections = {
        lualine_a = {
          {"searchcount",padding=0},
        }, --, color="Search" --'mode'
        lualine_b = {
          {"%5L:%l|%c",padding={left=0,right=1}},
        },
        lualine_c = {
          {"%m%r%h%<[%{fnamemodify(expand('%'), ':.')}]"}
        },
        lualine_x = {
          {'encoding'},
          {'fileformat'}
        },
        lualine_y = {
          {"%{strftime('%H:%M')}",padding=0}
          --[[{
            function() return require("noice").api.status.command.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
          },
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
          },
          {
            function() return "  " .. require("dap").status() end,
            cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
          },]]
        }, --'progress'
        lualine_z = { {"",padding=0} } --"os.date("%R")"
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {}
    },
    config = function(_, opts)

      require('lualine').setup(opts)
      local groups = {
        { group = "a", highlight = "Search" },
        { group = "b", highlight = "CursorLineNr" },
        { group = "c", highlight = "Visual" }
      }
      local modes = { "normal", "inactive", "replace", "visual", "terminal", "insert", "command" }
      for _, group in pairs(groups) do
        for _, mode in ipairs(modes) do
          vim.api.nvim_set_hl(0, "lualine_"..group.group.."_"..mode, { link = group.highlight } )
        end
      end
    end,
  },
}
