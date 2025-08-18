local M = {}

M.runcmd_menus = {}

M.open_menu = function(menu)
  local menu_value = M.runcmd_menus[menu]
  if menu_value == nil then
    vim.notify("Menu '" .. menu .. "' doesn't exist")
    return
  end
  require("runcmd.picker").open({ results = menu_value, })
end

M.runcmd_commands = {
  {
    name = "Example", description = "Run example print function command",
    cmd = function() print("ANONYMOUS LUA FUNCTION") end,
  },
}

M.open = function()
  require("runcmd.picker").open({ results = M.runcmd_commands, })
end

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

M.add_commands = function(items)
  M.runcmd_commands = mergeTables(M.runcmd_commands, items)
end

M.add_menu_commands = function(menu_name, items)
  local menu = M.runcmd_menus[menu_name]
  if menu == nil then
    M.runcmd_menus[menu_name] = items
    table.insert(M.runcmd_commands, {
      name = menu_name .. " ->",
      cmd = function() require("runcmd.picker").open({ results = M.runcmd_menus[menu_name], }) end,
    })
  else
    M.runcmd_menus[menu_name] = mergeTables(menu, items)
  end
end

---- example
--require("base.command").add_menu_commands("ababab git", {
--  { name = "open", cmd = "Git", description = ":Git" },
--})

return M
