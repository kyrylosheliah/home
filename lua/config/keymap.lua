vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<Esc>", '<cmd>nohlsearch<cr>', { desc = "No search highlight" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = 'Move selected lines down' })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = 'Move selected lines up' })

vim.keymap.set("n", "Q", "<nop>") -- unmap

--vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

--vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
--vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
--vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
--vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

--vim.keymap.set(
--  "n",
--  "<leader>lsdkfjlsdkfj",
--  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
--  { desc = "[E]dit Word Object" }
--)

--vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
