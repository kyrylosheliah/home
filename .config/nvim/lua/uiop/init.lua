local script_namespace = debug.getinfo(1, 'S').source
vim.g.username = script_namespace:match("[/\\]([%a%d_.-]+)[/\\][%a%d_.-]+%.lua")

local username = vim.g.username

require(username .. ".base")

if vim.g.vscode == nil then
  require(username .. ".lazy")
end
