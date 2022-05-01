local private = require'private'
local kutils = require'private.keybindutils'
local keymap = vim.keymap.set
local splits = require'private.splits'

keymap('n', 'qq', '%', {})

kutils.declmaps('n', {
  ['<leader>ot'] = 'silent !alacritty&';
  ['<leader>oT'] = private.openTerm;
  ['<leader>ol'] = require'private.logbuf'.toggle;
  ['<leader>os'] = 'SymbolsOutline';
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
  ['<leader>bw'] = function()
    local buflist = vim.fn.getbufinfo({buflisted = 1})
    local c = 0
    local lastbuf
    for _, buf in pairs(buflist) do
      if #buf.windows == 0 and buf.changed == 0 then
        c = c + 1
        lastbuf = buf.name
        vim.api.nvim_buf_delete(buf.bufnr, {force=false})
      end
    end
    if c > 1 then
      print("Wiped "..c.." buffers")
    elseif c == 1 then
      print('Wiped '..lastbuf)
    else
      print('No buffers wiped')
    end
  end;
})

-- Remap <C-w><key> to <M-<key>>
do
  -- Set maps to be used with windows
  local function winCmd(key)
      keymap('n', ('<M-%s>'):format(key), ('<cmd>wincmd %s<cr>'):format(key), {noremap = true})
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
  combo = "<C-p>",
  run = vim.lsp.buf.signature_help,
  mode = "i",
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
  private.keymapf {
    "n",
    gitcmd_prefix .. "C",
    function()
      local repo = private.askfor { "Git repo: ", "git@github.com:Diegovsky/", "none" }
      local where = private.askfor {
        "Where should it be: ",
        vim.fn.getenv "HOME" .. "/Projects",
        "dir",
      }
      if repo and where then
        vim.cmd(("Git clone '%s' '%s'"):format(repo, where))
      end
    end,
    opt = { noremap = true },
  }
end

-- Omnifunc mappings
do
  local opt = {noremap = false}
  --  Map C-Spc to omnifunc if no lsp is present.
  if vim.fn.maparg("<C-Space>", "i") then
    keymap("i", "<C-Space>", "<C-x><C-o>", opt)
  end
  keymap("o", "<Tab>", "<C-N>", opt)
  keymap("o", "<S-Tab>", "<C-P>", opt)
end

-- Add copy and pasting like common GUIs.
kutils.declmaps('n', {
  y = 'y';
  Y = 'Y';
  P = 'P';
  p = 'p';
}, kutils.prefix('"+'), kutils.fmt("<M-%s>"))

kutils.declmaps('i', {
  v = '"+p';
  V = '"+P';
  p = 'p';
  P = 'P';
}, kutils.prefix('<C-o>'), kutils.fmt("<C-%s>"))
