local private = require'private'
local kutils = require'private.keybindutils'
local splits = require'private.splits'

local keymap = vim.api.nvim_set_keymap

local function openTerm(cmd)
  splits.split()
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

local normalkeymap = kutils.declmaps('n', {
  ['<leader>oT'] = 'silent !alacritty&';
  ['<leader>ot'] = openTerm;
  ['<leader>mr'] = startguilerepl;
  ['<M-i>'] =  function() splits.state = false end;
  ['<M-o>'] =  function() splits.state = true end;
  ['<M-n>'] = splits.split;
  ['<leader>hrr'] = 'luafile '..NVIM_INIT_FILE;
  ['<leader>hhr'] = function() package.loaded['private.lspcfg'] = nil; dofile(NVIM_INIT_FILE) end;
  ['<leader>hpi'] = 'PackerInstall';
  ['<leader>hpu'] = 'PackerUpdate';
  ['<leader>cd']  = 'Telescope zoxide list';
  ['<leader>of']  = 'Telescope oldfiles';
  ['<leader>tn'] = 'tabnew';
  ['<leader>tc'] = 'tabclose';
  ['<leader><leader>'] = 'Telescope find_files';
  ['<leader>fg'] = 'Telescope live_grep';
  ['<M-h>'] = 'TmuxNavigateLeft';
  ['<M-j>'] = 'TmuxNavigateDown';
  ['<M-k>'] = 'TmuxNavigateUp';
  ['<M-l>'] = 'TmuxNavigateRight';
})

-- Remap <C-w><key> to <M-<key>>
do
  -- Set maps to be used with windows
  local function winCmd(opts)
      local key = opts.key
      local command = opts.command
      keymap('n', ('<M-%s>'):format(key), ('<cmd>wincmd %s<cr>'):format(command), {noremap = true})
  end

  local winkeys = 'wHJKLT|_=<>'
  for key in winkeys:gmatch('.') do
    winCmd(key)
  end
end

kutils.declmaps('n',
 {
  o = require'projection'.goto_project;
  a = require'projection'.add_project;
  d = require'projection'.remove_project;
 },
 nil,
 kutils.prefix"<leader>p"
)

private.keymapf {
  combo = '<C-p>';
  run = vim.lsp.buf.signature_help;
  mode = 'i';
}
do
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
kutils.declmaps('n', {
  y = 'y';
  Y = 'Y';
  P = 'P';
  p = 'p';
}, kutils.prefix('"+'), kutils.fmt("<M-%s>"))

--[[ keymap('v', '<M-y>', '"+y', {})
keymap('n', '<M-p>', '"+p', {})
keymap('n', '<M-P>', '"+P', {}) ]]
