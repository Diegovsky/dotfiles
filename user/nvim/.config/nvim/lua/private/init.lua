local M ={keybinds={}}

function M.normpath(s)
    if s:sub(#s, #s) ~= '/' then
        return s .. '/'
    end
    return s
end

function M.merge(a, b)
    a = a or {}
    for k, v in pairs(b or {}) do
        a[k] = v
    end
    return a
end

function M.cached(f, ...)
  local value = nil;
  local args = {...};
  return function()
    if value == nil then
      value = f(unpack(args))
    end
    return value
  end
end

function M.askfor(t)
  local prompt, text, typ = M.get_pargs(t, {'prompt', 'text', 'type'},
                                           {text=vim.fn.getcwd(), type='file'})
  -- The docs say 'typ' should be `nothing`.
  -- Nil does not work, so this workaround is needed.
  if typ ~= 'none' then
    return vim.fn.input(prompt, text, typ)
  else
    return vim.fn.input(prompt, text)
  end
end

function M.get_pargs(t, args, defaults)
  local retlist = {}
  defaults = defaults or {}
  for index, name in ipairs(args) do
    local newvalue = t[index] or t[name] or defaults[name]
    -- This is necessary to handle nils
    retlist[index] = newvalue
  end
  return unpack(retlist)
end

local chars = {}
-- A..Z
for i=0,25 do
    table.insert(chars, string.char(65+i))
end
-- a..z
for i=0,25 do
    table.insert(chars, string.char(97+i))
end
-- 0..10
for i=0,9 do
    table.insert(chars, string.char(48+i))
end

function M.randomstring(a, b)
    local min
    local max
    if b then
        min = a
        max = b
    else
        min = 1
        max = a
    end

    if min > max then
        error('Expected max to be greater than min')
    elseif min <= 0 then
        error('Min must be positive')
    elseif max <= 0 then
        error('Max must be positive')
    end
    local buf = ''
    for _=0,math.random(min, max) do
        buf = buf .. chars[math.random(#chars)]
    end
    return buf
end

function M.randomboolean(chance)
    chance = chance or 0.5
    return math.random() <= chance
end

function M.ensuretype(value, type_, name)
    name = name or 'argument'
    if type(value) ~= type_ then
       error(('Expected `%s` to be `%s`, found %S'):format(name, type_, type(value)), 1)
    end
    return value
end

function M.ensurecallable(value, name)
  if type(value) == 'function' then
    return value
  elseif type(value) == 'table' and getmetatable(value).__call then
    return value
  else
    error(("Expected '%s' to be callable, got `%s` instead."):format(name, type(value)), 2)
  end
end

-- Call a lua function with a keybind.
-- Gives you the hability to map a key to a lua function.
-- @param t.mode the vim mode [Default: 'n']
-- @param t.combo the key combination to be bound
-- @param t.run the function to be run
-- @param t.args the args to pass to the function [Default: {}]
-- @param t.opt neovim's keymap options.
function M.keymapf(t)
  local mode, combo, run, args, opt = M.get_pargs(t, {'mode', 'combo', 'run', 'args', 'options'}, {
    mode = 'n';
    args = {};
  })
  mode = M.ensuretype(mode, 'string', 'mode')
  combo = M.ensuretype(combo, 'string', 'combo')
  opt = M.merge({noremap=true}, opt)
  M.ensurecallable(run, 'run')

  if #args > 0 then
      local wrapper = function()
          run(unpack(args))
      end
      run = wrapper
  end
  table.insert(M.keybinds, run)

  vim.api.nvim_set_keymap(mode, combo, ('<cmd>lua require"private".keybinds[%s]()<cr>'):format(#M.keybinds), opt)
end

function M.debug(...)
    print(vim.inspect(...))
    return ...
end

function M.t(s) return vim.api.nvim_replace_termcodes(s, true, true, true) end
return M
