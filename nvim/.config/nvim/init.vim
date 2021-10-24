call plug#begin(stdpath('data') . '/plugins')

Plug 'tpope/vim-sensible'
Plug 'neovim/nvim-lspconfig'
Plug 'onsails/lspkind-nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python -m chadtree deps'}
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} 
Plug 'b3nj5m1n/kommentary'
Plug 'tpope/vim-surround'
Plug 'nvim-treesitter/playground', {'on': '<Plug>TSPlaygroundToggle'}
" Plug 'vim-ctrlspace/vim-ctrlspace'
Plug 'unblevable/quick-scope' 
Plug 'glepnir/dashboard-nvim'
Plug 'eraserhd/parinfer-rust', {'do': 'cargo build --release'}
Plug 'windwp/nvim-autopairs'
Plug 'Olical/conjure'

" Autotag
Plug 'tpope/vim-ragtag'

" Vim git
Plug 'tpope/vim-fugitive'

" Async tasks
Plug 'skywind3000/asynctasks.vim'
Plug 'skywind3000/asyncrun.vim'

" Auto Completion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/vim-vsnip'
Plug 'ray-x/lsp_signature.nvim'

" Vala support
Plug 'arrufat/vala.vim', {'for': 'vala'}

" telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" themes 
Plug 'navarasu/onedark.nvim'

" Debug adapters
Plug 'Pocco81/DAPInstall.nvim'
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'

call plug#end()


let mapleader = ' ' 

let g:CtrlSpaceDefaultMappingKey = "<C-space> "
let g:CtrlSpaceLoadLastWorkspaceOnStart = 1
let g:CtrlSpaceSaveWorkspaceOnSwitch = 1
let g:CtrlSpaceSaveWorkspaceOnExit = 1

let g:nvim_config_folder = stdpath('config') . '/'
let g:nvim_init_file = nvim_config_folder . 'init.vim'

let g:asyncrun_open = 6

set splitright
set splitbelow

let files = [
\ 'keybinds',
\ 'config',
\]

for f in files
	let x = g:nvim_config_folder . f . '.vim'
	if filereadable(x)
		execute 'source' x
	endif
endfor

" Local plugin
execute 'set' 'rtp+=' . g:nvim_config_folder .. 'plugins/projection.nvim'

execute 'luafile' g:nvim_config_folder . 'main.lua'
