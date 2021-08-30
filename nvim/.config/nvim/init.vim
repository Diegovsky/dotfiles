call plug#begin(stdpath('config') . 'init.vim')

Plug 'tpope/vim-sensible'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe' 
Plug 'onsails/lspkind-nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python -m chadtree deps'}
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} 
Plug 'b3nj5m1n/kommentary'
Plug 'tpope/vim-surround'
Plug 'nvim-treesitter/playground'
Plug 'hrsh7th/nvim-compe'
Plug 'hrsh7th/vim-vsnip'
Plug 'vim-ctrlspace/vim-ctrlspace'
Plug 'unblevable/quick-scope' 
Plug 'glepnir/dashboard-nvim'
Plug 'eraserhd/parinfer-rust', {'do': 'cargo build --release'}
Plug 'windwp/nvim-autopairs'
Plug 'Olical/conjure'
Plug 'mfussenegger/nvim-dap'

" Async tasks
Plug 'skywind3000/asynctasks.vim'
Plug 'skywind3000/asyncrun.vim'

" telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/playground'

" themes 
Plug 'navarasu/onedark.nvim'

call plug#end()

let mapleader = ' ' 

let g:CtrlSpaceDefaultMappingKey = "<C-space> "
let g:CtrlSpaceLoadLastWorkspaceOnStart = 1
let g:CtrlSpaceSaveWorkspaceOnSwitch = 1
let g:CtrlSpaceSaveWorkspaceOnExit = 1

let g:nvim_config_folder = expand('$HOME/.config/nvim/')
let g:nvim_init_file = nvim_config_folder . 'init.vim'

let g:asyncrun_open = 6

let files = [
\ 'keybinds',
\ 'commands',
\ 'config',
\]

for f in files
	let x = g:nvim_config_folder . f . '.vim'
	if filereadable(x)
		execute 'source' x
	endif
endfor

execute 'luafile' g:nvim_config_folder . 'main.lua'
