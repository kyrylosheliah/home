--vim.o.fileencoding = 'utf-8' -- written
--vim.o.encoding = 'utf-8' -- shown

local g = vim.g

local disable_plugins = function()
  -- g.loaded_matchit         = 1
  -- g.loaded_matchparen      = 1
  g.loaded_2html_plugin      = 1
  g.loaded_getscript         = 1
  g.loaded_getscriptPlugin   = 1
  g.loaded_gzip              = 1
  g.loaded_logiPat           = 1
  g.loaded_netrw             = 1
  g.loaded_netrwFileHandlers = 1
  g.loaded_netrwPlugin       = 1
  g.loaded_netrwSettings     = 1
  g.loaded_rrhelper          = 1
  g.loaded_tar               = 1
  g.loaded_tarPlugin         = 1
  g.loaded_tutor_mode_plugin = 1
  g.loaded_vimball           = 1
  g.loaded_vimballPlugin     = 1
  g.loaded_zip               = 1
  g.loaded_zipPlugin         = 1
end

local disable_providers = function()
  g.loaded_node_provider = 0
  g.loaded_perl_provider = 0
  g.loaded_ruby_provider = 0
end

disable_plugins()
disable_providers()

local opt = vim.opt   -- Set options (global/buffer/windows-scoped)

--opt.shellslash = true

opt.showmode = true

opt.mouse = 'a'                       -- Enable mouse support
--opt.clipboard = 'unnamed' -- * register (or PRIMARY) - copy-on-select, can be pasted with the mouse3
opt.clipboard = 'unnamedplus' -- + register (or CLIPBOARD) - copied with ^C and pasted with ^V
opt.completeopt = 'menuone,noinsert,noselect'  -- Autocomplete options

opt.number = true           -- Show line number
opt.relativenumber = true
opt.showmatch = true        -- Highlight matching parenthesis
opt.splitright = true       -- Vertical split to the right
opt.splitbelow = true       -- Horizontal split to the bottom
opt.ignorecase = true       -- Ignore case letters when search
opt.smartcase = true        -- Ignore lowercase for the whole pattern
opt.linebreak = false        -- Wrap on word boundary
opt.breakindent = false
--opt.showbreak = "~"
opt.wrap = true
opt.termguicolors = true    -- Enable 24-bit RGB colors
opt.laststatus = 3          -- Set global statusline

opt.autoindent = true
opt.smartindent = true
opt.expandtab = false
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "html",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "json",
    "jsonc",
    "css",
    "lua",
  },
  callback = function()
    vim.opt_local.autoindent = false
    vim.opt_local.smartindent = false
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "Makefile",
    "c",
    "cpp",
    "cs",
  },
  callback = function()
    vim.opt_local.autoindent = false
    vim.opt_local.smartindent = false
    vim.opt_local.expandtab = false
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
})

opt.hidden = true           -- Enable background buffers
opt.lazyredraw = true       -- Faster scrolling

opt.swapfile = false
opt.backup = false

opt.undodir = vim.fn.stdpath("data") .. "/.undo/"
opt.undofile = true

opt.hlsearch = true
opt.incsearch = true

opt.scrolloff = 8
opt.signcolumn = "yes"

opt.updatetime = 300

--opt.colorcolumn = "80"

-- Disable nvim intro
opt.shortmess:append "sI"
