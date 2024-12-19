local opt = vim.opt

local g = vim.g

--vim.cmd("language en_US") -- windows only

--o.fileencoding = 'utf-8' -- written
--o.encoding = 'utf-8' -- shown

g.have_nerd_font = true

--g.loaded_matchit = 0
--g.loaded_matchparen = 0
--g.loaded_getscript = 0
--g.loaded_getscriptPlugin = 0
--g.loaded_gzip = 0
--g.loaded_logiPat = 0
--g.loaded_netrw = 0
--g.loaded_netrwFileHandlers = 0
--g.loaded_netrwPlugin = 0
--g.loaded_netrwSettings = 0
--g.loaded_rrhelper = 0
--g.loaded_tar = 0
--g.loaded_tarPlugin = 0
--g.loaded_tutor_mode_plugin = 0
--g.loaded_vimball = 0
--g.loaded_vimballPlugin = 0
--g.loaded_zip = 0
--g.loaded_zipPlugin = 0

--opt.shellslash = true

opt.showmode = true

opt.mouse = "a" -- Enable mouse support

-- unnamed, *, PRIMARY - copy-on-select register, pasted with middlemouse or mouse3
-- unnamedplus, +, CLIPBOARD - copied with ^C and pasted with ^V
-- "unnamed,unnamedplus"
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"

--opt.completeopt = "menu,menuone,noinsert"
opt.completeopt = ""
opt.spell = false

opt.number = true
opt.relativenumber = true
opt.cursorline = false 
opt.colorcolumn = "" --"80,120"
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.signcolumn = "yes" -- yes, number

opt.splitright = true
opt.splitbelow = true

opt.showmatch = false
opt.ignorecase = true
opt.smartcase = true

opt.linebreak = false
opt.breakindent = false
opt.wrap = true
opt.termguicolors = true -- Enable 24-bit RGB colors
opt.laststatus = 2 -- Set global statusline

opt.hidden = true -- Enable background buffers

opt.swapfile = false
opt.backup = false

opt.undodir = vim.fn.stdpath("data") .. "/.undo/"
opt.undofile = true

opt.hlsearch = true
opt.incsearch = true -- Preview substitutions live, as you type!
opt.inccommand = "split"

opt.updatetime = 300
-- Decrease mapped sequence wait time
--opt.timeoutlen = 300

-- Disable nvim intro
--opt.shortmess:append("sI")

local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("conceal_enforce"),
  pattern = {
-- Remove conceal for oil file browser
    "oil",
-- Fix conceallevel for json files
    "json",
    "jsonc",
    "json5",
  },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})
