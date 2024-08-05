local lsp_zero = require('lsp-zero')
--lsp_zero.preset('recommended')
--lsp_zero.set_preferences({
--    --suggest_lsp_servers = false,
--    sign_icons = {
--        error = 'E',
--        warn = 'W',
--        hint = 'H',
--        info = 'I'
--    }
--})
lsp_zero.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<F3>", vim.lsp.buf.format, opts)
  vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "<F5>", vim.lsp.buf.workspace_symbol, opts)
end)
lsp_zero.setup()

require('mason').setup()
require('mason-lspconfig').setup({
  handlers = {
    lsp_zero.default_setup,
    --lua_ls = function()
    --  -- (Optional) configure lua language server
    --  local lua_opts = lsp_zero.nvim_lua_ls()
    --  require('lspconfig').lua_ls.setup(lua_opts)
    --end,
  },
  --ensure_installed = {
  --  'tsserver',
  --  'eslint',
  --  'html',
  --  'cssls',
  --}
})
require('lspconfig').unocss.setup({
  filetypes = { "html", "javascriptreact", "rescript", "typescriptreact", "vue", "svelte", "typescript" },
  root_dir = require('lspconfig').util.root_pattern('unocss.config.js', 'unocss.config.ts', 'uno.config.js', 'uno.config.ts'),
})


vim.diagnostic.config({
    virtual_text = true
})

local cmp = require('cmp')
local cmp_action = lsp_zero.cmp_action()
--local cmp_select = {behavior = cmp.SelectBehavior.Select}
cmp.setup({
  experimental = {
    ghost_text = { hl_group = { "VertSplit" } },
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    --['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    --['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<S-Tab>'] = nil,
    ['<S>'] = nil,
  }),
  sources = {
    --{ name = "codeium" },
    { name = 'nvim_lsp' },
    { name = "path" },
    --{ name = "buffer" },
    --{ name = "luasnip" },
    ----{ name = "lua_ls" },
    --{ name = "vimls" },
    --{ name = "nvim_lua" },
    --{ name = "css-lsp" },
    --{ name = "css-variables-language-server" },
    { name = "emmet_language_server" },
    { name = "html" },
    { name = "unocss" },
  }
})
--vim.api.nvim_create_autocmd('FileType', { callback = function()
--    require('cmp').setup.buffer({
--
--    })
--  end,
--})
