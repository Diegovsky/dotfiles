local M = {}

local utils = require'private'

function M.prefix(prefix)
  return function(key)
    return prefix..key
  end
end

function M.vimcmd(prefix)
  prefix = prefix or ""
  return function(val)
    return('<cmd>%s%s<cr>'):format(prefix, val)
  end
end
--- @alias DeclarativeMapping string|fun(...)

--- @param t table<string, DeclarativeMapping>
--- @param mapval fun(string):string
--- @param mapkey fun(string):string
--- @param opts table<string, string>
function M.declmaps(mode, t, mapval, mapkey, opts)
  mapkey = mapkey or function (key)
    return key
  end
  mapval = mapval or function (val)
    return ("<cmd>%s<cr>"):format(val)
  end
  opts = utils.merge(opts, {noremap=true})
  for key, value in pairs(t) do
    key = mapkey(key)
    if type(value) == "string" then
      value = mapval(value)
      vim.api.nvim_set_keymap(mode, key, value, opts)
    else
      utils.keymapf{
        mode = mode,
        combo = key,
        run = value,
        opt = opts,
      }
    end
  end
end

return M
