if vim.uv.os_uname().sysname == "Windows_NT" then
  vim.cmd("language en_US") -- windows only
end

--vim.o.fileencoding = 'utf-8' -- written
--vim.o.encoding = 'utf-8' -- shown

--vim.opt.fileformat = "unix"

vim.g.have_nerd_font = false

--vim.g.loaded_matchit = 0
--vim.g.loaded_matchparen = 0
--vim.g.loaded_getscript = 0
--vim.g.loaded_getscriptPlugin = 0
--vim.g.loaded_gzip = 0
--vim.g.loaded_logiPat = 0
--vim.g.loaded_netrw = 0
--vim.g.loaded_netrwFileHandlers = 0
--vim.g.loaded_netrwPlugin = 0
--vim.g.loaded_netrwSettings = 0
--vim.g.loaded_rrhelper = 0
--vim.g.loaded_tar = 0
--vim.g.loaded_tarPlugin = 0
--vim.g.loaded_tutor_mode_plugin = 0
--vim.g.loaded_vimball = 0
--vim.g.loaded_vimballPlugin = 0
--vim.g.loaded_zip = 0
--vim.g.loaded_zipPlugin = 0

vim.opt.showmode = false

vim.opt.mouse = "a" -- Enable mouse support

-- Schedule the setting after `UiEnter` because it can increase startup-time.
-- unnamed, *, PRIMARY - copy-on-select register, pasted with middlemouse or mouse3
-- unnamedplus, +, CLIPBOARD - copied with ^C and pasted with ^V
-- "unnamed,unnamedplus"
vim.schedule(function()
  if not vim.env.SSH_TTY then
    vim.opt.clipboard = "unnamedplus"
  end
end)

--opt.completeopt = "menu,menuone,noinsert"
vim.opt.spell = false

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = false
vim.opt.colorcolumn = "80,120"
--vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes" -- yes, number

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.showmatch = false

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.linebreak = false
vim.opt.breakindent = false
vim.opt.wrap = false
vim.opt.termguicolors = true -- Enable 24-bit RGB colors
vim.opt.laststatus = 2 -- Set global statusline

vim.opt.hidden = true -- Enable background buffers

vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.undodir = vim.fn.stdpath("data") .. "/.undo/"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true -- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

vim.opt.updatetime = 250
-- Decrease mapped sequence wait time
--vim.opt.timeoutlen = 300 -- the default was 1000 that time

-- Disable nvim intro
--vim.opt.shortmess:append("sI")

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
