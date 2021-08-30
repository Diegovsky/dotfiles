local M ={}

function M.normpath(s)
    if s:sub(#s, #s) ~= '/' then
        return s .. '/'
    end
    return s
end

function M.merge(a, b)
    b = b or {}
    for k, v in pairs(a) do
        b[k] = v
    end
    return b
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
    assert(type(value) == type_, 'Expected `'..name..'` to be string, found ' .. type_)
end

function M.keymapf(t)
    local mode = t.mode or 'n'
    local combo = assert(t.combo, '`combo` must be specified')
    local run = assert(t.run, '`run` must me specified')
    local args = t.args or {}
    local opt = M.merge({noremap=true}, t.options)

    M.ensuretype(mode, 'string', 'mode')
    M.ensuretype(combo, 'string', 'combo')
    M.ensuretype(run, 'function', 'run')

    local function generate()
        return 'diegovsky#'..M.randomstring(8)
    end

    local tmpname = generate()
    -- Avoid collisions
    while _G[tmpname] do
        tmpname = generate()
    end

    local wrapper = {}
    if #args > 0 then
        wrapper.run = function()
            run(unpack(args))
        end
    else
        wrapper.run = run
    end
    _G[tmpname] = setmetatable(wrapper, {
        __call = function(self)
            self.run()
        end;
        __tostring = t.name
    })

 vim.api.nvim_set_keymap(mode, combo, ('<cmd>lua _G["%s"]()<cr>'):format(tmpname), opt)
end

function M.debug(...)
    print(...)
    if select('#', ...) <= 1 then
        return ...
    else
        return setmetatable({ ... }, {
            __tostring = function(self)
                return '('..table.concat(self, ', ')..')'
            end
        })
    end
end

function M.t(s) return vim.api.nvim_replace_termcodes(s, true, true, true) end
return M
