local set = vim.keymap.set
local esc_key_code = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
-- local cr_key_code = vim.api.nvim_replace_termcodes("<CR>", true, false, true)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- use `5@q` instead
set("n", "Q", "<nop>") -- unmap

set("n", "<leader>w", "<cmd>w<cr>", { desc = "Write" })
set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
set("n", "<leader>x", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })
--set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Reminder:
-- <C-w>d : hover diagnostics
-- <C-w>w : step into floating window

-- Reminder:
-- mz : mark cursor location
-- `z : go to `z` location

-- Reminder: jumplist with `:jumps`
-- <C-o> : jump back
-- <C-i> : jump forward

local function save_clipboard()
  local reg = '+'
  local val = vim.fn.getreg(reg, true)
  local typ = vim.fn.getregtype(reg)
  vim.fn.setreg('0', val, typ)
end
local function load_clipboard()
  -- "<CMD>let @+ = getreg(\'0\')<CR>"
  local reg = '0'
  local val = vim.fn.getreg(reg, true)
  local typ = vim.fn.getregtype(reg)
  vim.fn.setreg('+', val, typ)
end
set({ "n", "x" }, "<leader>y", save_clipboard)
set({ "n", "x" }, "<leader>Y", load_clipboard)
set("n", "<leader>p", '\"0p')
set("n", "<leader>P", '\"0P')
set("x", "<leader>p", '\"_d\"0P')
set("x", "<leader>P", '\"_dP')

-- better scroll
set("n", "<C-d>", "<C-d>zz")
set("n", "<C-u>", "<C-u>zz")
set("n", "<C-f>", "<C-f>zz")
set("n", "<C-b>", "<C-b>zz")
set("n", "<C-i>", "<C-i>zz")
set("n", "<C-o>", "<C-o>zz")

-- better indenting
set("v", "<", "<gv")
set("v", ">", ">gv")

set({ "i", "n" }, "<esc>", function()
  vim.cmd("nohlsearch") --"<cmd>noh<cr><esc>"
  vim.cmd.redrawstatus()
  vim.api.nvim_feedkeys(esc_key_code, "n", false)
end, { desc = "Clear hlsearch, redraw statusline and feed <esc>" })

set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

set("n", "<C-w><C-j>", "<cmd>resize -4<cr>", { desc = "Decrease Window Height" })
set("n", "<C-w><C-k>", "<cmd>resize +4<cr>", { desc = "Increase Window Height" })
set("n", "<C-w><C-h>", "<cmd>vertical resize -4<cr>", { desc = "Decrease Window Width" })
set("n", "<C-w><C-l>", "<cmd>vertical resize +4<cr>", { desc = "Increase Window Width" })

