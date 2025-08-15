return {
  'mbbill/undotree',
  keys = {
    { "<leader>u", vim.cmd.UndotreeToggle, mode = "n", desc = "undo tree" },
  },
  config = function()
    local is_windows = not vim.fn.has('macunix')
    if is_windows then
      vim.g.undotree_DiffCommand = "FC"
    end
  end,
}
