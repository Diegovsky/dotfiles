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
  l = 'main.lua',
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
        return startguilerepl()
    end
    local sockname = '/tmp/nvim.guile.'..token..'.socket'
    vim.g['conjure#client#guile#socket#pipename'] = sockname
    vim.cmd('split')
    vim.cmd(('terminal %s')
        :format("guile '--listen=%s'")
        :format(sockname))
    vim.b.hidden = true
end

local function openterminal()
    vim.cmd('split')
    vim.cmd('terminal')
end

local function openExternTerm()
  vim.cmd('silent !alacritty&')
end

-- Keybinds
local keymapf = utils.keymapf
keymapf{
    combo = '<leader>ot',
    run = openterminal,
    name = 'Open Terminal'
}

keymapf{
    combo = '<leader>oT',
    run = openExternTerm,
    name = 'Open External Terminal'
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


keymapf{
  combo = '<M-i>',
  run = function()
    vim.g['diegovsky#^splithor'] = false
  end,
  name = 'Set split direction to horizontal',
}

keymapf{
  combo = '<M-o>',
  run = function()
    vim.g['diegovsky#^splithor'] = true
  end,
  name = 'Set split direction to horizontal',
}

keymapf{
  combo = '<M-n>',
  run = function()
    if vim.g['diegovsky#^splithor'] then
      vim.cmd('new')
    else
      vim.cmd('vnew')
    end
  end,
  name = 'Open a new window'
}


-- Cd to config folder
for key, file in pairs(key_to_file) do
    utils.keymapf {
        combo = '<leader>cf'..key;
        run = openconfigfile;
        args = {file};
        name = ('Open file %s'):format(file);
    }
end

-- Remap <C-w><key> to <M-<key>>
local simple_keys = 'hjklwHJKLT|_=' .. '<>'
for k in simple_keys:gmatch('.') do
    winCmd {key=k, command=k }
end

utils.keymapf{
  combo = '<leader>po';
  run = require'projection'.goto_project;
  name = 'Open a project'
}

utils.keymapf{
  combo = '<leader>pa';
  run = function() require'projection'.add_project() end;
  name = 'Add a project'
}

utils.keymapf{
  combo = '<leader>pd';
  run = function() require'projection'.remove_project() end;
  name = 'Add a project'
}

utils.keymapf {
  combo = '<C-p>';
  run = function() vim.lsp.buf.signature_help() end;
  mode = 'i';
  name = 'LSP show signature help'
}

local gitcmds = {
  ['A'] = 'add -A';
  ['c'] = 'commit';
  ['ca'] = 'commit --amend';
  ['p'] = 'pull';
  ['u'] = 'push';
}
for key, cmd in pairs(gitcmds) do
  keymap('n', ('<leader>g%s'):format(key), ('<cmd>Git %s<cr>'):format(cmd), {noremap=true})
end

if vim.fn.maparg('<C-Space>', 'i') then
  keymap('i', '<C-Space>', '<C-x><C-o>', {})
end
-- Window commands that don't have the same name as their key
--[[ local key_map = {
}
for key, wincmd in pairs(key_map) do
    winCmd {key=key, command=wincmd}
end ]]
