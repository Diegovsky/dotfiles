local M = {}

local utils = require'private'

function M.prefix(prefix)
  return function(key)
    return prefix..key
  end
end

function M.fmt(template)
  return function(arg)
    return template:format(arg)
  end
end

function M.vimcmd(prefix)
  prefix = prefix or ""
  return function(val)
    return('<cmd>%s%s<cr>'):format(prefix, val)
  end
end
--- @alias DeclarativeMapping string|fun(...)

--- @param mode string|string[]
--- @param t table<string, DeclarativeMapping>
--- @param mapval fun(string):string
--- @param mapkey fun(string):string
--- @param opts table<string, string>
function M.declmaps(mode, t, mapval, mapkey, opts)
  mapval = mapval or M.vimcmd()

  mapkey = mapkey or function (key)
    return key
  end

  opts = utils.merge(opts, {noremap=true})

  for key, value in pairs(t) do
    key = mapkey(key)
    if type(value) == "string" then
      value = mapval(value)
    end
    vim.keymap.set(mode, key, value, opts)
  end
end

return M
