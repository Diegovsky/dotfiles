local utils = require'utils'

local keymap = vim.api.nvim_set_keymap
local DEBUG = DEBUG or false
if DEBUG then
    keymap = function(mode, combo, action, options)
        print(mode, combo, action, options)
        vim.api.nvim_set_keymap(mode, combo, action, options)
    end
end

-- Set maps to be used with windows
local function winCmd(opts)
    local prefix = opts.prefix or '<M-%s>'
    local cmdfmt = opts.cmdfmt or '<cmd>wincmd %s<cr>'
    keymap('n', prefix:format(opts.key), cmdfmt:format(opts.command), {noremap = true})
end

-- Remap <C-w><key> to <M-<key>>
local simple_keys = 'hjklwnHJKLT'
for k in simple_keys:gmatch('.') do
    winCmd {key=k, command=k }
end

-- Window commands that don't have the same name as their key
local key_map = {
}
for key, wincmd in pairs(key_map) do
    winCmd {key=key, command=wincmd}
end
keymap('n', '<M-i>', '<cmd>set splitright<cr>', {noremap=true})
keymap('n', '<M-o>', '<cmd>set splitbelow<cr>', {noremap=true})


-- Open file using key
local key_to_file = {
  c = 'config.vim',
  k = 'keybinds.vim',
  i = 'init.vim',
  l = 'lua/main.lua',
  kl = 'lua/keybinds.lua',
}

local function kmapf(t)
    local mode = t.mode or 'n'
    local combo = t.combo
    local run = t.run
    local args = t.args or {}
    local opt = utils.merge({noremap=true}, t.options)

    local function generate()
        return 'diegovsky#'..utils.randomstring(6)
    end

    local tmpname = generate()
    -- Avoid collisions
    while _G[tmpname] do
        tmpname = generate()
    end

    if #args > 0 then
        local wrapper = function()
            run(unpack(args))
        end
        _G[tmpname] = wrapper
    else
        _G[tmpname] = run
    end

    keymap(mode, combo, ('<cmd>lua _G["%s"]()<cr>'):format(tmpname), opt)
end

-- OpenConfigFile
local openconfigfile = function(f)
    local settings_dir = utils.normpath( vim.g.nvim_config_folder )
    vim.api.nvim_command('vsplit')
    vim.api.nvim_command(("edit %s"):format(settings_dir .. f))
end

for key, file in pairs(key_to_file) do
    kmapf {
        combo = ('<leader>cf%s'):format(key),
        run = openconfigfile,
        args = {file}
    }
end
-- Cd to config folder

-- Start Guile REPL
local function startguilerepl()
    local token = _G['sgr#session']
    if not token then
        _G['sgr#session'] = utils.randomstring(8, 12)
    end
    local sockname = '/tmp/nvim.'..token..'.socket'
    vim.g['conjure#client#guile#socket#pipename'] = sockname
    vim.cmd('vsplit')
    vim.cmd(('terminal %s')
        :format("guile '--listen=%s'")
        :format(sockname))
    vim.b.hidden = true
end

kmapf{
    combo = '<leader>mr',
    run = startguilerepl
}

local function openterminal()
    vim.cmd('vsplit')
    vim.cmd('terminal')
end

kmapf{
    combo = '<leader>ot',
    run = openterminal,
}
