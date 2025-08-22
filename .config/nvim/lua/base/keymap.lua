local set = vim.keymap.set
local esc_key_code = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
local cr_key_code = vim.api.nvim_replace_termcodes("<CR>", true, false, true)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- use `5@q` instead
set("n", "Q", "<nop>") -- unmap

set("n", "<leader>w", "<cmd>w<cr>", { desc = "Write" })
set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
set("n", "<leader>x", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- Reminder:
-- <C-w>d : hover diagnostics
-- <C-w>w : step into floating window

-- Reminder:
-- mz : mark cursor location
-- `z : go to `z` location

-- Reminder: jumplist with `:jumps`
-- <C-o> : jump back
-- <C-i> : jump forward

-- the opposite of `<S-j>` or `J` or "join", "break"
local BreakLine = function(args)
  args = args or {}
  local after = args.after or false
  local visual = args.visual or false
  if visual then
    vim.api.nvim_feedkeys("\"_d", "n", false)
  end
  if after then
    vim.api.nvim_feedkeys("a", "n", false)
  else
    vim.api.nvim_feedkeys("i", "n", false)
  end
  vim.api.nvim_feedkeys(cr_key_code, "n", false)
  vim.api.nvim_feedkeys(esc_key_code, "n", false)
  if after or vim.fn.col(".") ~= 1 then
    vim.api.nvim_feedkeys("d", "n", false)
    vim.api.nvim_feedkeys("v", "n", false)
    vim.api.nvim_feedkeys("0", "n", false)
  end
end
set("n", "<leader>b", BreakLine, { desc = "Break the line before the cursor" })
set("n", "<leader>B", function() BreakLine({ after = true }) end, { desc = "Break the line after the cursor" })
set("x", "<leader>b", function() BreakLine({ visual = true }) end, { desc = "Break the line outside selection" })

-- local function load_yank()
--   local reg = '0'
--   local val = vim.fn.getreg(reg, true)
--   local typ = vim.fn.getregtype(reg)
--   vim.fn.setreg('+', val, typ)
-- end
--set("x", "<leader>p", "\"_dP")
set("n", "<leader>y", "<CMD>let @+ = getreg(\'0\')<CR>")
set("x", "<leader>y", "<CMD>let @+ = getreg(\'0\')<CR>")
set("n", "<leader>p", "\"0p")
set("x", "<leader>p", "\"0p")

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

-- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

