vim.cmd("language en_US")

--vim.o.fileencoding = 'utf-8' -- written
--vim.o.encoding = 'utf-8' -- shown

local g = vim.g

g.have_nerd_font = false

-- g.loaded_matchit         = 0
-- g.loaded_matchparen      = 0

g.loaded_getscript = 0
g.loaded_getscriptPlugin = 0
g.loaded_gzip = 0
g.loaded_logiPat = 0
g.loaded_netrw = 0
g.loaded_netrwFileHandlers = 0
g.loaded_netrwPlugin = 0
g.loaded_netrwSettings = 0
g.loaded_rrhelper = 0
g.loaded_tar = 0
g.loaded_tarPlugin = 0
g.loaded_tutor_mode_plugin = 0
g.loaded_vimball = 0
g.loaded_vimballPlugin = 0
g.loaded_zip = 0
g.loaded_zipPlugin = 0

g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

local opt = vim.opt -- Set options (global/buffer/windows-scoped)

--opt.shellslash = true

opt.showmode = true

opt.mouse = "a" -- Enable mouse support

-- unnamed, *, PRIMARY - copy-on-select register, pasted with mouse3
-- unnamedplus, +, CLIPBOARD - copied with ^C and pasted with ^V
opt.clipboard = "unnamedplus"

--opt.completeopt = "menu,menuone,preview,noinsert" -- Autocomplete options

opt.number = true
opt.relativenumber = true
opt.cursorline = false
opt.scrolloff = 10
opt.signcolumn = "yes" -- "number"

opt.splitright = true
opt.splitbelow = true

opt.showmatch = true
opt.ignorecase = true
opt.smartcase = true

opt.linebreak = false -- Wrap on word boundary
opt.breakindent = false
opt.showbreak = "+"
opt.wrap = false--true
opt.termguicolors = true -- Enable 24-bit RGB colors
opt.laststatus = 2 -- Set global statusline

opt.hidden = true -- Enable background buffers
--opt.lazyredraw = true -- Faster scrolling

opt.swapfile = false
opt.backup = false

opt.undodir = vim.fn.stdpath("data") .. "/.undo/"
opt.undofile = true

opt.hlsearch = true
opt.incsearch = true
-- Preview substitutions live, as you type!
opt.inccommand = "split"

opt.updatetime = 300
-- Decrease mapped sequence wait time
--opt.timeoutlen = 300

--opt.colorcolumn = "80"

-- Disable nvim intro
opt.shortmess:append("sI")

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- and `:help 'listchars'`
-- ↲ ↵ ↴ ▏ ␣ ·
opt.list = true
opt.listchars = {
  eol = "↲",
  tab = "│ ",
  trail = "·",
  --space = '·',
  multispace = "╎ ",
  nbsp = "␣",
  --extends = "▶",
  --precedes = "◀",
}

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
