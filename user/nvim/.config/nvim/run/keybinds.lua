local private = require'private'

local keymap = vim.api.nvim_set_keymap

local function split()
  if vim.g['diegovsky#^splithor'] then
    vim.cmd('split')
  else
    vim.cmd('vsplit')
  end
end

local function openTerm(cmd)
  split()
  vim.cmd('terminal '..(cmd or ""))
end

-- Start Guile REPL
local function startguilerepl()
    local token = _G['sgr#session']
    if not token then
        _G['sgr#session'] = private.randomstring(8, 12)
        return startguilerepl()
    end
    local sockname = '/tmp/nvim.guile.'..token..'.socket'
    vim.g['conjure#client#guile#socket#pipename'] = sockname
    vim.cmd('split')
    openTerm(("guile '--listen=%s'"):format(sockname))
    vim.b.hidden = true
end

local vimcmd = function(cmd) return ('<cmd>%s<cr>'):format(cmd) end

local normalkeymap = {
  ['<leader>oT'] = function() vim.cmd('silent !alacritty&') end,
  ['<leader>ot'] = openTerm,
  ['<leader>mr'] = startguilerepl,
  ['<M-i>'] =  function() vim.g['diegovsky#^splithor'] = false end,
  ['<M-o>'] =  function() vim.g['diegovsky#^splithor'] = true end,
  ['<M-n>'] = split;
  ['<leader>hrr'] = vimcmd('luafile '..NVIM_INIT_FILE);
  ['<leader>hpi'] = vimcmd'PackerInstall';
  ['<leader>hpu'] = vimcmd'PackerUpdate';
  ['<leader>tn'] = vimcmd'tabnew';
  ['<leader>tc'] = vimcmd'tabclose';
  ['<leader><leader>'] = vimcmd'Telescope find_files';
  ['<leader>fg'] = vimcmd'Telescope live_grep';
}

for key, cmd in pairs(normalkeymap) do
  if type(cmd) == 'string' then
    keymap('n', key, cmd, {noremap=true})
  else
    private.keymapf{'n', key, cmd}
  end
end

-- Set maps to be used with windows
local function winCmd(opts)
    local prefix = opts.prefix or '<M-%s>'
    local cmdfmt = opts.cmdfmt or '<cmd>wincmd %s<cr>'
    keymap('n', prefix:format(opts.key), cmdfmt:format(opts.command), {noremap = true})
end

-- Remap <C-w><key> to <M-<key>>
local simple_keys = 'hjklwHJKLT|_=' .. '<>'
for k in simple_keys:gmatch('.') do
    winCmd {key=k, command=k }
end

private.keymapf{
  combo = '<leader>po';
  run = require'projection'.goto_project;
  name = 'Open a project'
}

private.keymapf{
  combo = '<leader>pa';
  run = require'projection'.add_project;
  name = 'Add a project'
}

private.keymapf{
  combo = '<leader>pd';
  run = require'projection'.remove_project;
  name = 'Add a project'
}

private.keymapf {
  combo = '<C-p>';
  run = vim.lsp.buf.signature_help;
  mode = 'i';
  name = 'LSP show signature help'
}
do
  local gitcmd_prefix = "<leader>g"
  local gitcmds = {
    ['A'] = 'add -A';
    ['c'] = 'commit';
    ['ca'] = 'commit --amend';
    ['p'] = 'pull';
    ['u'] = 'push';
  }
  for key, cmd in pairs(gitcmds) do
    keymap('n', gitcmd_prefix..key, ('<cmd>Git %s<cr>'):format(cmd), {noremap=true})
  end
  -- Keybind for a special git clone
  private.keymapf{'n', gitcmd_prefix..'C', function()
    local repo = private.askfor{'Git repo: ', 'git@github.com:Diegovsky/', 'none'}
    local where = private.askfor{'Where should it be: ', vim.fn.getenv('HOME')..'/Projects', 'dir'} if repo and where then
      vim.cmd(("Git clone '%s' '%s'"):format(repo, where))
    end
  end, opt={noremap=true}}
end

--  Map C-Spc to omifunc if no lsp is present.
if vim.fn.maparg('<C-Space>', 'i') then
  keymap('i', '<C-Space>', '<C-x><C-o>', {})
end

-- Add copy and pasting like common GUIs.
private.keymapf{ 'i', '<M-v>', function()
  vim.cmd'normal "+p'
  vim.fn.cursor(vim.fn.line('.'), vim.fn.col('.')+1)
end }
keymap('v', '<M-y>', '"+y', {})
keymap('n', '<M-p>', '"+p', {})
