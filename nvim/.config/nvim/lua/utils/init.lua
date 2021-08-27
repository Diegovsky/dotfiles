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

function M.t(s) return vim.api.nvim_replace_termcodes(s, true, true, true) end
return M
