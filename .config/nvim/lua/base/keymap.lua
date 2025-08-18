vim.g.mapleader = " "
vim.g.maplocalleader = " "

local set = vim.keymap.set

set("n", "<leader>w", "<cmd>w<cr>", { desc = "Write" })
set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
--set("n", "<leader>x", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })
--set("n", "<leader>x", '<cmd>x<cr>', { desc = "Write or Exit" })

-- greatest remap ever indeed
set("x", "<leader>p", "\"_dP")
-- Interferes with telescope command palette menu
--set("x", "<leader>c", "\"_c")

-- Reminder: jumplist with `:jumps`
-- <C-o> : jump back
-- <C-i> : jump forward

-- better indenting
set("v", "<", "<gv")
set("v", ">", ">gv")

local esc_key_code = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
set({ "i", "n" }, "<esc>", function()
  vim.cmd("nohlsearch") --"<cmd>noh<cr><esc>"
  vim.cmd.redrawstatus()
  vim.api.nvim_feedkeys(esc_key_code, "n", false)
end, { desc = "Clear hlsearch, redraw statusline and feed <esc>" })

set("n", "Q", "<nop>") -- unmap

-- Reminder: tab movement
-- :tabnew
-- :tabclose
-- :tabedit {filename}
-- :tabnext or gt or Ctrl+PageUp
-- :tabprev or gT or Ctrl+PageDown
-- :tabfirst, :tablast, :tabrewind
-- {i}g[tT]
-- :tabmove {N}, :tabmove +{N}, :tabmove -{N}

-- Move to window using the <ctrl> hjkl keys
set("n", "<C-Down>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
set("n", "<C-Up>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
set("n", "<C-Left>", "<C-w>h", { desc = "Go to Left Window", remap = true })
set("n", "<C-Right>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Resize window using <ctrl> arrow keys
set("n", "<C-S-Up>", "<cmd>resize +1<cr>", { desc = "Increase Window Height" })
set("n", "<C-S-Down>", "<cmd>resize -1<cr>", { desc = "Decrease Window Height" })
set("n", "<C-S-Left>", "<cmd>vertical resize -1<cr>", { desc = "Decrease Window Width" })
set("n", "<C-S-Right>", "<cmd>vertical resize +1<cr>", { desc = "Increase Window Width" })
--[[

-- quickfix
set("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
set("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })
set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Next Quickfix" })
set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Previous Quickfix" })
set("n", "<leader>k", "<cmd>lnext<CR>zz")
set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

set("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
set("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

- better up/down
set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- buffers
set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
set("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
set("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
set("n", "<leader>bd", LazyVim.ui.bufremove, { desc = "Delete Buffer" })
set("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

]]
