local dbg = require("private").debug

local function Lua(tbl)
  local body = tbl.args
  local eq = body:find('=')
  if eq then
    local assignment = body:sub(1, eq-1)
    print(assignment)
    dbg(loadstring(body .. '; return '.. assignment)())
  else
    dbg(loadstring('return '..body)())
  end
end

local function LuaReload(tbl)
  local name = tbl.fargs[1]
  if package.loaded[name] then
    package.loaded[name] = nil
    return require(name)
  else
    error("Package " .. name .. " not present")
  end
end

vim.api.nvim_create_user_command("Lua", Lua, { complete = "lua", nargs = "+" })
vim.api.nvim_create_user_command("LuaReload", LuaReload, {
  nargs = "+",
  complete = function(lead)
    local packages = vim.tbl_keys(package.loaded)
    packages = vim.tbl_filter(function (el)
      return string.find(el, lead, nil, true)
    end, packages)
    return packages
  end,
})
