local utils = require'utils'

local keymap = vim.api.nvim_set_keymap

-- Set maps to be used with windows
local function winCmd(opts)
    local prefix = opts.prefix or '<M-%s>'
    local cmdfmt = opts.cmdfmt or '<cmd>wincmd %s<cr>'
    keymap('n', prefix:format(opts.key), cmdfmt:format(opts.command), {noremap = true})
end

-- Open file using key
local key_to_file = {
  c = 'config.vim',
  k = 'keybinds.vim',
  i = 'init.vim',
  l = 'lua/main.lua',
  kl = 'lua/keybinds.lua',
}

-- OpenConfigFile
local openconfigfile = function(f)
    local settings_dir = utils.normpath( vim.g.nvim_config_folder )
    vim.api.nvim_command('vsplit')
    vim.api.nvim_command(("edit %s"):format(settings_dir .. f))
end


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

local function openterminal()
    vim.cmd('vsplit')
    vim.cmd('terminal')
end

-- Keybinds
local keymapf = utils.keymapf
keymapf{
    combo = '<leader>ot',
    run = openterminal,
    name = 'Open Terminal'
}

keymapf{
    combo = '<leader>mr',
    run = startguilerepl,
    name = 'Start guile Repl'
}
keymapf{
    combo = '<leader>hhr',
    run = function() package.loaded.utils = nil end,
    name = 'Hard reload the config'
}


keymap('n', '<M-i>', '<cmd>set splitright<cr>', {noremap=true})
keymap('n', '<M-o>', '<cmd>set splitbelow<cr>', {noremap=true})


-- Cd to config folder
for key, file in pairs(key_to_file) do
    utils.keymapf {
        combo = '<leader>cf'..key,
        run = openconfigfile,
        args = {file},
        name = ('Open file %s'):format(file)
    }
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
