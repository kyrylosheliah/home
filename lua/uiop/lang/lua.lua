if True then return {} end

return {

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "lua",
        "luadoc",
        "luap",
      },
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "lua_ls",
      },
    },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = {
      ensure_installed = {
        "stylua",
        "selene",
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        lua = { "selene" },
      },
    },
  },

  --#######################################
  {
    "folke/lazydev.nvim",
    dependencies = {
      { "Bilal2453/luvit-meta", lazy = true },
    },
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- Library paths can be absolute
        "~/projects/my-awesome-lib",
        -- Or relative, which means they will be resolved from the plugin dir.
        "lazy.nvim",
        "luvit-meta/library",
        -- It can also be a table with trigger words / mods
        -- Only load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        -- always load the LazyVim library
        "LazyVim",
        -- Only load the lazyvim library when the `LazyVim` global is found
        { path = "LazyVim", words = { "LazyVim" } },
        -- Load the wezterm types when the `wezterm` module is required
        -- Needs `justinsgithub/wezterm-types` to be installed
        { path = "wezterm-types", mods = { "wezterm" } },
        -- Load the xmake types when opening file named `xmake.lua`
        -- Needs `LelouchHe/xmake-luals-addon` to be installed
        { path = "xmake-luals-addon/library", files = { "xmake.lua" } },
      },
      -- disable when a .luarc.json file is found
      enabled = function(root_dir)
        return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
      end,
      integrations = {
        -- Fixes lspconfig's workspace management for LuaLS
        -- Only create a new workspace if the buffer is not part
        -- of an existing workspace or one of its libraries
        lspconfig = true,
        -- add the cmp source for completion of:
        -- `require "modname"`
        -- `---@module "modname"`
        cmp = true,
        -- same, but for Coq
        coq = false,
      },
    },
  },

  --[[{ -- optional completion source for require statements and module annotations
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })
    end,
  },]]
  --#######################################

  --[[{
    "mfussenegger/nvim-dap",
  },]]

  --[[ neotest ]]
}
