syntax enable
setglobal synmaxcol=512
filetype plugin indent on
let g:vimsyn_embed = 'l'
setglobal number relativenumber
setglobal mouse=a
setglobal splitright

" Theme stuff
let g:onedark_style = 'warmer'
colorscheme onedark
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

" ctrlspace
let g:CtrlSpaceSaveWorkspaceOnSwitch = 1
let g:CtrlSpaceSaveWorkspaceOnExit = 1
" Conjure config
let g:conjure#filetype#scheme = "conjure.client.guile.socket"
let g:conjure#client#guile#socket#pipename = "guile-repl.socket"

" Recommended
setglobal nocompatible
setglobal hidden
setglobal encoding=utf-8

" Folding
setglobal foldmethod=expr
setglobal foldexpr=nvim_treesitter#foldexpr()
setglobal nofoldenable
setglobal foldlevelstart=99

let $NVIM_CMD = "echo 'Failed to connect to nvim.\nQuitting.'; exit"
let $GIT_EDITOR = 'nvr -cc split --remote-wait'

" tabbing for lua files
autocmd FileType lua setlocal softtabstop=2 shiftwidth=2
" tabbing for xml files
autocmd FileType xml setlocal softtabstop=2 shiftwidth=2

" Actually close git files after closing the buffer.
autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete
