local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local username = vim.g.username

require("lazy").setup(
  {
    { import = username .. ".plugins" },
    { import = username .. ".lsp" },
    { import = username .. ".languages" },
  },
  {
    change_detection = {
      notify = false,
    },
  }
)
