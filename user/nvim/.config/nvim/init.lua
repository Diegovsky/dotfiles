vim.cmd("let mapleader=' '")

NVIM_CONFIG_FOLDER = vim.fn.stdpath('config') .. '/'
NVIM_INIT_FILE = NVIM_CONFIG_FOLDER..'/init.lua'

vim.g.nvim_config_folder = NVIM_CONFIG_FOLDER
vim.g.nvim_init_file = NVIM_INIT_FILE
vim.g.asyncrun_open = 12

-- vim.cmd('set rtp+='..NVIM_CONFIG_FOLDER..'')

require'packer'.startup(function(use)
  -- Sensible vim defaults
  use {
    'tpope/vim-surround',
  }
  use 'tpope/vim-sensible'

  -- dhall support
  use 'vmchale/dhall-vim'
  use 'neovim/nvim-lspconfig'
  use 'onsails/lspkind-nvim'
  use {'ms-jpq/chadtree', {branch='chad', run = 'python -m chadtree deps'}}
  use { 'kyazdani42/nvim-web-devicons',
    config = function ()
      -- Icon theme
      require'nvim-web-devicons'.setup {
        override = { };
        default = true;
      }
    end
  }
  use {'nvim-treesitter/nvim-treesitter', {run = '<cmd>TSUpdate'}} 
  use { 'b3nj5m1n/kommentary',
    config = function ()
      -- Comment plugin settings
      require'kommentary.config'.use_default_mappings()
    end
  }
  use {'nvim-treesitter/playground', {cmd='<Plug>TSPlaygroundToggle'} }
  use 'unblevable/quick-scope'
  -- use 'glepnir/dashboard-nvim'
  use {'eraserhd/parinfer-rust', {run = 'cargo build --release'} }
  use { 'windwp/nvim-autopairs',
    config = function ()
      require('nvim-autopairs').setup {
        disable_filetype = {"TelescopePrompt", "terminal"},
      }
    end
  }
  use 'Olical/conjure'
  use 'tpope/vim-fugitive'
  use {'hrsh7th/nvim-cmp',
        requires={
          'hrsh7th/cmp-nvim-lsp',
          'hrsh7th/vim-vsnip'
        }
      }
  use 'ray-x/lsp_signature.nvim'
  use {'arrufat/vala.vim', {ft='vala'}}
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'
  use 'navarasu/onedark.nvim'
  use 'Pocco81/DAPInstall.nvim'
  use 'mfussenegger/nvim-dap'
  use 'rcarriga/nvim-dap-ui'
  use {
    NVIM_CONFIG_FOLDER..'/plugins/projection.nvim',
    as = 'projection',
    config = function ()
      require'projection'.init{enable_sorting=true}
    end
  }
end)

local scandir = require'plenary.scandir'
scandir.scan_dir(NVIM_CONFIG_FOLDER..'/scripts', {on_insert = function(file)
    local result, msg = pcall(function() vim.cmd('source '..file) end)
    if not result then
        print(msg)
    end
    end})

dofile(NVIM_CONFIG_FOLDER..'/main.lua')
