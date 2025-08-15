-- usage
--require("base.lsp").configure()

local M = {}

vim.o.pumheight = 10

vim.diagnostic.config({
  --[[virtual_text = {
    prefix = "█",--"💢",--"",
  },]]
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  signs = false,
  float = {
    focusable = false,
    style = "minimal",
    --source = "always", -- "if_many",
    --header = "",
    --prefix = "",
  },
  virtual_text = {
    format = function(diagnostic)
      -- Replace newline and tab characters with space for more compact diagnostics
      local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
      return message
    end,
  },
})


-- indent

vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.smarttab = true
--vim.opt.expandtab = false
--vim.opt.shiftwidth = 4
--vim.opt.tabstop = 4
--vim.opt.softtabstop = 4

-- ↳ ↲ ↵ ↴ ▏ ␣ · ╎ │ ▶ ◀
local tabchar = "↹"
local spacing = "·"
local empty = " "
local space = "␣"
local indent = "│"
local block = "█"
local focus = "×"
vim.opt.showbreak = block
vim.opt.fillchars = {
  lastline = block,
  --eob = block,
}
vim.opt.list = true
local function create_listchars(tab, leadmultispace)
  return {
    eol = "↲",
    tab = tab,
    nbsp = space,
    --extends = block,
    --precedes = block,
    trail = focus,
    space = empty,
    multispace = spacing,
    leadmultispace = leadmultispace,
  }
end

M.apply_indent = function(use_tabs, space_count)
  --local editorconfig_exists = editorconfig ~= nil and editorconfig ~= false
  local editorconfig_exists = vim.fn.filereadable(vim.fn.getcwd() .. "/.editorconfig")
  local padding_len = 0
  local opt = vim.opt_local
  if editorconfig_exists == true then
    local editorconfig = vim.b.editorconfig
    use_tabs = editorconfig.indent_style ~= "space"
    padding_len = editorconfig.indent_size - 1
  else
    padding_len = space_count - 1
    opt.autoindent = false
    opt.expandtab = not use_tabs
    opt.shiftwidth = space_count
    opt.tabstop = space_count
    opt.softtabstop = space_count
  end
  local tab = ""
  local leadmultispace = ""
  if use_tabs then
    tab = indent .. empty
    leadmultispace = space .. string.rep(spacing, padding_len)
  else
    tab = tabchar .. empty
    leadmultispace = indent .. string.rep(spacing, padding_len)
  end
  opt.listchars = create_listchars(tab, leadmultispace)
end

-- default indent and non-text symbols
M.apply_indent(true, 4)

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
