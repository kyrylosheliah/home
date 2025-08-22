-- usage
--require("base.lsp").configure()

local M = {}

-- blink.cmp state variable
M.show_automatically = true;

vim.o.pumheight = 10

vim.diagnostic.config({
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  signs = false,
  float = {
    focusable = true,
    source = "if_many",
  },
  virtual_text = true,
  --virtual_lines = { current_line = true },
})

-- indent

-- ↳ ↲ ↵ ↴ ▏ ␣ · ╎ │ ▶ ◀
local chars = {
  tab = "↹",
  spacing = "·",
  empty = " ",
  space = "␣",
  indent = "│",
  block = "█",
  --vim.opt.showbreak = block
  --vim.opt.fillchars = {
  --  lastline = block,
  --  --eob = block,
  --}
  focus = "×",
}

local function create_listchars(params)
  params = params or {}
  local tab = params.tab or ""
  local leadmultispace = params.leadmultispace or ""
  return {
    eol = "↲",
    tab = tab,
    nbsp = chars.space,
    --extends = block,
    --precedes = block,
    trail = chars.focus,
    space = chars.empty,
    multispace = chars.spacing,
    leadmultispace = leadmultispace,
  }
end

M.apply_indent = function(params)
  params = params or {}
  local default = params.default == true
  local use_tabs = default or (params.use_tabs == true)
  local space_count = default and 4 or (params.space_count or 4)
  local editorconfig_exists = vim.fn.filereadable(vim.fn.getcwd() .. "/.editorconfig")
  local padding_len = 0
  local opt = vim.opt_local
  if editorconfig_exists == true then
    local editorconfig = vim.b.editorconfig
    use_tabs = editorconfig.indent_style ~= "space"
    padding_len = editorconfig.indent_size - 1
  else
    if default == true then
      opt.autoindent = true
      opt.smartindent = true
      opt.smarttab = true
      opt.expandtab = false
    else
      opt.autoindent = false
      opt.smartindent = false
      opt.smarttab = false
      opt.expandtab = not use_tabs
    end
    padding_len = space_count - 1
    opt.shiftwidth = space_count
    opt.tabstop = space_count
    opt.softtabstop = space_count
  end
  local tab = use_tabs and chars.indent or chars.tab
  opt.list = true
  opt.listchars = create_listchars({
    tab = tab .. chars.empty,
    leadmultispace = chars.indent .. string.rep(chars.spacing, padding_len)
  })
end

-- lsp

M.get_capabilities = function()
  if M.capabilities == nil then
    M.capabilities = require('blink.cmp').get_lsp_capabilities()
  end
  return M.capabilities
end

M.spawn_config = function(extra_options)
  extra_options = extra_options or {}
  local default_options = {
    capabilities = M.get_capabilities(),
    --flags = {
    --  debounce_text_changes = 250,
    --},
    --autostart = true,
    --root_dir = function(fname)
    --  return require("lspconfig/util").find_git_ancestor(fname) or vim.fn.getcwd()
    --end,
  }
  local options = vim.tbl_deep_extend("force", {}, default_options, extra_options)
  return options
end

M.configure = function(server_name, extra_options)
  vim.lsp.config(server_name, M.spawn_config(extra_options))
  vim.lsp.enable(server_name)
end

return M
