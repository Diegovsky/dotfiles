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
  openTerm(("guile '--listen=%s'"):format(sockname))
  vim.b.hidden = true
  vim.g['conjure#client#guile#socket#pipename'] = sockname
  vim.cmd('ConjureConnect')
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
  ['<leader>hhr'] = function() package.loaded['private.lspcfg'] = nil; dofile(NVIM_INIT_FILE) end;
  ['<leader>hpi'] = vimcmd'PackerInstall';
  ['<leader>hpu'] = vimcmd'PackerUpdate';
  ['<leader>cd']  = vimcmd('Telescope zoxide list');
  ['<leader>of']  = vimcmd('Telescope oldfiles');
  ['<leader>tn'] = vimcmd'tabnew';
  ['<leader>tc'] = vimcmd'tabclose';
  ['<leader><leader>'] = vimcmd'Telescope find_files';
  ['<leader>fg'] = vimcmd'Telescope live_grep';
  ['<M-h>'] = vimcmd'TmuxNavigateLeft';
  ['<M-j>'] = vimcmd'TmuxNavigateDown';
  ['<M-k>'] = vimcmd'TmuxNavigateUp';
  ['<M-l>'] = vimcmd'TmuxNavigateRight';
}

for key, cmd in pairs(normalkeymap) do
  local options = {noremap=true}
  if type(cmd) == 'table' then
    cmd = cmd.action
    options = private.merge(options, cmd.options)
  end

  if type(cmd) == 'string' then
    keymap('n', key, cmd, options)
  else
    private.keymapf{'n', key, cmd, options=options}
  end
end

-- Set maps to be used with windows
local function winCmd(opts)
    local prefix = opts.prefix or '<M-%s>'
    local cmdfmt = opts.cmdfmt or '<cmd>wincmd %s<cr>'
    keymap('n', prefix:format(opts.key), cmdfmt:format(opts.command), {noremap = true})
end

-- Remap <C-w><key> to <M-<key>>
local simple_keys = 'wHJKLT|_=' .. '<>'
for k in simple_keys:gmatch('.') do
    winCmd {key=k, command=k }
end

private.keymapf{
  combo = '<leader>po';
  run = require'projection'.goto_project;
}

private.keymapf{
  combo = '<leader>pa';
  run = require'projection'.add_project;
}

private.keymapf{
  combo = '<leader>pd';
  run = require'projection'.remove_project;
}

private.keymapf {
  combo = '<C-p>';
  run = vim.lsp.buf.signature_help;
  mode = 'i';
}
do
  local kutils = require'private.keybindutils'
  local gitcmd_prefix = "<leader>g"
  local gitcmds = {
    ['A'] = 'add -A';
    ['c'] = 'commit';
    ['ca'] = 'commit --amend';
    ['p'] = 'pull';
    ['u'] = 'push';
    ['a'] = 'add %';
    ['s'] = 'status';
  }
  kutils.declmaps(
    'n',
    gitcmds,
    kutils.vimcmd("Git "),
    kutils.prefix(gitcmd_prefix)
  )

  -- Keybind for a special git clone
  private.keymapf{'n', gitcmd_prefix..'C', function()
    local repo = private.askfor{'Git repo: ', 'git@github.com:Diegovsky/', 'none'}
    local where = private.askfor{'Where should it be: ', vim.fn.getenv('HOME')..'/Projects', 'dir'} if repo and where then
      vim.cmd(("Git clone '%s' '%s'"):format(repo, where))
    end
  end, opt={noremap=true}}
end

--  Map C-Spc to omnifunc if no lsp is present.
if vim.fn.maparg('<C-Space>', 'i') then
  keymap('i', '<C-Space>', '<C-x><C-o>', {})
end

-- Omnifunc mappings
do
  keymap('o', '<Tab>', '<C-N>', {})
  keymap('o', '<S-Tab>', '<C-P>', {})
end

-- Add copy and pasting like common GUIs.
private.keymapf{ 'i', '<M-v>', function()
  vim.cmd'normal "+p'
  -- advance cursor a character
  vim.fn.cursor(vim.fn.line('.'), vim.fn.col('.')+1)
end }
keymap('v', '<M-y>', '"+y', {})
keymap('n', '<M-p>', '"+p', {})
keymap('n', '<M-P>', '"+P', {})
