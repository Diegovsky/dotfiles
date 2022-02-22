syntax enable
setglobal synmaxcol=512
filetype plugin indent on
set omnifunc=syntaxcomplete#Complete
let g:vimsyn_embed = 'l'
set number relativenumber
set mouse=a
setglobal splitright
setglobal splitbelow
setglobal nowrap

setglobal guifont=FiraCode\ Nerd\ Font:h14

" Dashboard
let g:dashboard_default_executive ='telescope'

"Quick Scope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_buftype_blacklist = ['terminal', 'nofile']

" Tabs
setglobal expandtab
setglobal shiftwidth=4
setglobal softtabstop=4

if !exists('g:INIT_HAPPENED') == 1
    set expandtab<
    set shiftwidth<
    set softtabstop<
endif


" Conjure config
let g:conjure#filetype#scheme = 'conjure.client.guile.socket'

" Recommended
setglobal nocompatible
setglobal hidden
setglobal encoding=utf-8

" Folding
setglobal foldmethod=indent
setglobal nofoldenable
setglobal foldlevelstart=99

" Prevent Autopairs from messing with my stuff
let g:AutoPairsShortcutJump = "<C-n>"

" Vim termux navigator custom keybinds
let g:tmux_navigator_no_mappings = 1

let $NVIM_CMD = "echo 'Failed to connect to nvim.\nQuitting.'; exit"
let $GIT_EDITOR = 'nvr -cc split --remote-wait'

" tabbing for lua, xml, dart and coffee files
autocmd FileType lua,xml,dart,coffee setlocal softtabstop=2 shiftwidth=2

" Actually close git files after closing the buffer.
autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete

let g:INIT_HAPPENED = 1
