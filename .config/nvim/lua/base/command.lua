-- a global variable for the list of commands

vim.g.runcmd_commands = {
  {
    name = "Example", description = "Run example print function command",
    cmd = function() print("ANONYMOUS LUA FUNCTION") end,
  },
  { name = "Git", cmd = "Git", description = "Open Git" },
  {
    name = "Lsp ->",
    cmd = function()
      require('runcmd.picker').open({
        results = require('runcmd.commands.lsp'),
      })
    end,
    description = "Language Server commands",
  },
}

local function mergeTables(table1, table2)
  local result = {}
  for _, v in ipairs(table1) do
    table.insert(result, v)
  end
  for _, v in ipairs(table2) do
    table.insert(result, v)
  end
  return result
end

vim.g.add_commands = function(items)
  vim.g.runcmd_commands = mergeTables(vim.g.runcmd_commands, items)
end

