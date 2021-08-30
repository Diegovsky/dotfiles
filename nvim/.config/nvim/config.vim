syntax enable
set synmaxcol=512
filetype plugin indent on
let g:vimsyn_embed = 'l'
set number relativenumber
set nowrap
set mouse=a
set splitright

" Theme stuff
let g:onedark_style = 'warmer'
colorscheme onedark
set guifont=FiraCode\ Nerd\ Font:h14

" Dashboard
let g:dashboard_default_executive ='telescope'

"Quick Scope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_buftype_blacklist = ['terminal', 'nofile']

" Tabs
set expandtab
set shiftwidth=4
set softtabstop=4

" ctrlspace
let g:CtrlSpaceSaveWorkspaceOnSwitch = 1
let g:CtrlSpaceSaveWorkspaceOnExit = 1
" Conjure config
let g:conjure#filetype#scheme = "conjure.client.guile.socket"
let g:conjure#client#guile#socket#pipename = "guile-repl.socket"

" Recommended
set nocompatible
set hidden
set encoding=utf-8

" Folding
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set nofoldenable
set foldlevelstart=99



" tabbing for lua files
autocmd FileType lua setlocal softtabstop=2 shiftwidth=2
