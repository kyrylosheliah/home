vim.g.mapleader = " "
vim.g.maplocalleader = " "

local set = vim.keymap.set
local esc_key_code = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
local cr_key_code = vim.api.nvim_replace_termcodes("<CR>", true, false, true)

set("n", "<leader>w", "<cmd>w<cr>", { desc = "Write" })
set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
--set("n", "<leader>x", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })
--set("n", "<leader>x", '<cmd>x<cr>', { desc = "Write or Exit" })

-- Reminder:
-- mz : mark cursor location
-- `z : go to `z` location

-- the opposite of `<S-j>` or `J` or "join", "break"
local BreakLine = function(args)
  args = args or {}
  local after = args.after or false
  local visual = args.visual or false
  local indent = args.indent or false
  if visual then -- delete into the void register
    vim.api.nvim_feedkeys("\"_d", "n", false)
  end
  if after then
    vim.api.nvim_feedkeys("a", "n", false)
  else
    vim.api.nvim_feedkeys("i", "n", false)
  end
  vim.api.nvim_feedkeys(cr_key_code, "n", false)
  vim.api.nvim_feedkeys(esc_key_code, "n", false)
  if indent then
    return
  end
  vim.api.nvim_feedkeys("d", "n", false)
  -- if new line cursor is not on the first column, then
  if after or vim.fn.col(".") ~= 1 then
    vim.api.nvim_feedkeys("v", "n", false)
  end
  vim.api.nvim_feedkeys("0", "n", false)
end
set("n", "<leader>b", BreakLine, { desc = "Break the line before the cursor" })
set("n", "<leader>B", function() BreakLine({ after = true }) end, { desc = "Break the line after the cursor" })
set("x", "<leader>b", function() BreakLine({ visual = true }) end, { desc = "Break the line outside selection" })
set("n", "<leader>v", function() BreakLine({ indent = true }) end, { desc = "Break the line before the cursor, preserve indentation" })
set("n", "<leader>V", function() BreakLine({ indent = true, after = true }) end, { desc = "Break the line after the cursor, preserve indentation" })
set("x", "<leader>v", function() BreakLine({ indent = true, visual = true }) end, { desc = "Break the line outside selection, preserve indentation" })

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
