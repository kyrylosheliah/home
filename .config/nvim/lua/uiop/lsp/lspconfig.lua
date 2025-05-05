return {

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "Issafalcon/lsp-overloads.nvim",
    },
    opts = {
      ensure_installed = {
        "taplo", -- toml
        -- PYTHON
        "pyright",
        -- RUST
        "rust_analyzer", -- will use system installation if rustaceanvim is installed
      },
      handlers = {
        function(server_name) -- default handler
          local lsp = require(vim.g.username .. ".base.lsp")
          require("lspconfig")[server_name].setup({
            capabilities = lsp.spawn_common_capabilities(),
            on_attach = lsp.spawn_on_attach(),
            --[[flags = {
              debounce_text_changes = 150,
            },]]
            --autostart = true,
            root_dir = lsp.common_root_dir,
          })
        end,
      },
    },
  },

}
