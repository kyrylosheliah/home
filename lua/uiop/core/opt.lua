--vim.cmd("language en_US") -- windows only

--vim.o.fileencoding = 'utf-8' -- written
--vim.o.encoding = 'utf-8' -- shown

local g = vim.g

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

local opt = vim.opt

--opt.shellslash = true

opt.showmode = true

opt.mouse = "a" -- Enable mouse support

-- unnamed, *, PRIMARY - copy-on-select register, pasted with middlemouse or mouse3
-- unnamedplus, +, CLIPBOARD - copied with ^C and pasted with ^V
-- "unnamed,unnamedplus"
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"

opt.completeopt = "menu,menuone,noinsert" -- Autocomplete options

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 16
opt.signcolumn = "yes" -- yes, number

opt.splitright = true
opt.splitbelow = true

opt.showmatch = false
opt.ignorecase = true
opt.smartcase = true

opt.linebreak = false
opt.breakindent = false
opt.showbreak = "█"
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

--opt.colorcolumn = "80,120"

-- Disable nvim intro
--opt.shortmess:append("sI")

local function augroup(name)
  return vim.api.nvim_create_augroup("config.general_" .. name, { clear = true })
end

local indent_group = augroup("filetype_indent")
-- ↲ ↵ ↴ ▏ ␣ · ╎ │
opt.list = true
local eol = "↲"
local tab = "│ "
local trail = "·"
local nbsp = "␣"
local space = "·"
  --multispace = "│···",
  --extends = "▶",
  --precedes = "◀",
local two_space_listchars = {
  eol=eol, tab=tab, trail=trail, nbsp=nbsp, space=space,
  leadmultispace = "│·",
}
local four_space_listchars = {
  eol=eol, tab=tab, trail=trail, nbsp=nbsp, space=space,
  leadmultispace = "│···",
}
local tab_listchars = {
  eol=eol, tab=tab, trail=trail, nbsp=nbsp, space=space,
}
opt.listchars = tab_listchars
opt.autoindent = true
opt.smartindent = true
opt.smarttab = true
opt.expandtab = false
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
vim.api.nvim_create_autocmd("FileType", {
  group = indent_group,
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
    opt.listchars = two_space_listchars
    vim.opt_local.autoindent = false
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = indent_group,
  pattern = {
    "rust",
    "python",
  },
  callback = function()
    opt.listchars = four_space_listchars
    vim.opt_local.autoindent = false
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = indent_group,
  pattern = {
    "Makefile",
    "c",
    "cpp",
    "cs",
  },
  callback = function()
    opt.listchars = tab_listchars
    vim.opt_local.autoindent = false
    vim.opt_local.expandtab = false
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
})

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

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = {
    "text",
    "plaintex",
    "typst",
    "gitcommit",
    "markdown"
  },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
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

vim.g.bigfile_size = 1000000 * 2
vim.filetype.add({
  pattern = {
    [".*"] = {
      function(path, buf)
	  if vim.g.bigfile_size == nil then
	  return nil
	  end
        return vim.bo[buf]
            and vim.bo[buf].filetype ~= "bigfile"
            and path
            and vim.fn.getfsize(path) > vim.g.bigfile_size
            and "bigfile"
          or nil
      end,
    },
  },
})
