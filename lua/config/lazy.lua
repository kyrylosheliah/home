local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  'stevearc/oil.nvim',
  'Mofiqul/vscode.nvim',
  'lukas-reineke/indent-blankline.nvim',
  'mbbill/undotree',
  'laytan/cloak.nvim',
  'nvim-treesitter/nvim-treesitter',
  { 'nvim-telescope/telescope.nvim',
    --tag = '0.1.5',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
    }
  },
  { 'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = true,
    dependencies = {
      -- LSP Support
      'neovim/nvim-lspconfig',
      --- Uncomment the two plugins below if you want to manage the language servers from neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      -- Autocompletion
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      --'saadparwaiz1/cpm_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      -- Snippets
      'L3MON4D3/LuaSnip',
      'rafamadriz/friendly-snippets',
    }
  },
  'tpope/vim-fugitive',
  { "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  --{ "Exafunction/codeium.nvim",
  --  dependencies = {
  --    "nvim-lua/plenary.nvim",
  --    "hrsh7th/nvim-cmp",
  --  },
  --},
},
{
  config = {
    defaults = {
      --lazy = false
    }
  }
})
