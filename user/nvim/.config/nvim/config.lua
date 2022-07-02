vim.fn.setenv('NVIM_CMD', "echo 'Failed to connect to nvim.\nQuitting.'; exit")
vim.fn.setenv('NVIM_LISTEN_ADDRESS', vim.v.servername)
vim.fn.setenv('GIT_EDITOR', 'nvr --servername ' .. vim.v.servername .. ' -cc split --remote-wait')

vim.g.mapleader = " "
vim.o.showmode = false
vim.o.laststatus = 3
vim.o.termguicolors = true
vim.o.linebreak = true

vim.go.synmaxcol=512
vim.go.omnifunc="syntaxcomplete#Complete"
vim.go.number=true
vim.go.relativenumber=true
vim.go.mouse="a"
vim.go.splitright=true
vim.go.splitbelow=true
vim.go.wrap=false
vim.go.guifont="FiraCode Nerd Font:h14"
vim.go.expandtab=true
vim.go.shiftwidth=4
vim.go.softtabstop=4
vim.go.compatible=false
vim.go.hidden=true
vim.go.encoding="utf-8"
vim.go.foldmethod="indent"
vim.go.foldenable=false
vim.go.foldlevelstart=99

-- global options
vim.g['vimsyn_embed'] = 'l'
vim.g['do_filetype_lua'] = 1
vim.g['did_load_filetypes'] = 0
vim.g['dashboard_default_executive'] = 'telescope'
vim.g['qs_highlight_on_keys'] = {'f', 'F', 't', 'T'}
vim.g['qs_buftype_blacklist'] = {'terminal', 'nofile'}
vim.g['conjure#filetype#scheme'] = 'conjure.client.guile.socket'
vim.g['tmux_navigator_no_mappings'] = 1
