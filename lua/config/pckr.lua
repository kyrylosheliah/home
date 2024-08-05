local function bootstrap_pckr()
  local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"
  if not vim.loop.fs_stat(pckr_path) then
    vim.fn.system({
      'git',
      'clone',
      "--filter=blob:none",
      'https://github.com/lewis6991/pckr.nvim',
      pckr_path
    })
  end
  vim.opt.rtp:prepend(pckr_path)
end

bootstrap_pckr()

require('pckr').add{
  'mg979/vim-visual-multi',
  'stevearc/oil.nvim',
  'Mofiqul/vscode.nvim',
  'lukas-reineke/indent-blankline.nvim',
  'mbbill/undotree',
  'laytan/cloak.nvim',
  'nvim-treesitter/nvim-treesitter',
  { 'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    requires = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    }
  },
  { 'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = true,
    requires = {
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
    requires = { "nvim-lua/plenary.nvim" },
  },
  { "Exafunction/codeium.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
  },
}
