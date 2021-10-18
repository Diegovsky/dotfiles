local npairs = require'nvim-autopairs'
local rule = require'nvim-autopairs.rule'
local cond = require'nvim-autopairs.conds'

npairs.clear_rules()

local brackets = {'{}', '[]', '()'}

local rules = {
  rule('function ', 'end', 'lua')
    :end_wise(cond.none()),
  rule('do', 'end', 'lua')
    :end_wise(cond.none())
}

for _, brack in ipairs(brackets) do
  table.insert(rules, rule(brack:sub(1, 1), brack:byte(2, 2))
    :end_wise(function() return true end))
end

npairs.setup(rules)
--[[ require'nvim-ts-autotag'.setup{
  filetypes = {'html', 'xml'}
} ]]
