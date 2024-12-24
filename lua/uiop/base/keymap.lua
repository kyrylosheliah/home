vim.g.mapleader = " "
vim.g.maplocalleader = " "

local set = vim.keymap.set

set("n", "<leader>w", '<cmd>w<cr>', { desc = "Write" })
set("n", "<leader>q", '<cmd>q<cr>', { desc = "Quit" })
set("n", "<leader>x", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })
--set("n", "<leader>x", '<cmd>x<cr>', { desc = "Write or Exit" })

-- greatest remap ever indeed
set("x", "<leader>p", "\"_dP")

-- better indenting
set("v", "<", "<gv")
set("v", ">", ">gv")

-- Clear search with <esc>
set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

set("n", "Q", "<nop>") -- unmap

-- Move to window using the <ctrl> hjkl keys
set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Resize window using <ctrl> arrow keys
set("n", "<A-Up>", "<cmd>resize +1<cr>", { desc = "Increase Window Height" })
set("n", "<A-Down>", "<cmd>resize -1<cr>", { desc = "Decrease Window Height" })
set("n", "<A-Left>", "<cmd>vertical resize -1<cr>", { desc = "Decrease Window Width" })
set("n", "<A-Right>", "<cmd>vertical resize +1<cr>", { desc = "Increase Window Width" })
--[[

-- Move Lines
set("v", "J", ":m '>+1<CR>gv=gv", { desc = 'Move selected lines down' })
set("v", "K", ":m '<-2<CR>gv=gv", { desc = 'Move selected lines up' })
set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-- quickfix
set("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
set("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Next Quickfix" })
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Previous Quickfix" })
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

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
