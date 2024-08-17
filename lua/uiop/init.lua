local script_namespace = debug.getinfo(1, 'S').source
local is_macunix = vim.fn.has('macunix')
local slash = is_macunix and "/" or "\\"
vim.g.username = script_namespace:match("[/\\]([%a%d_.-]+)[/\\][%a%d_.-]+%.lua")
vim.print(vim.g.username)

local username = vim.g.username

require(username .. ".core")

if vim.g.vscode == nil then
  require(username .. ".lazy")
end
