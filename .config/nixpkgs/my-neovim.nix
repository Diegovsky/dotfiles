{ config, pkgs, lib, ... }:
let
  neovim2 = import ./neovim2.nix { inherit pkgs lib; };
  sourcePlugins = import ./sourcePlugins.nix { inherit pkgs lib; };
  neovimConfig = with neovim2; {
    enable = true;
    # defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    # package = pkgs.neovim-nightly;

    extraPackages = with pkgs; [
    	tree-sitter
    	gopls
    	rust-analyzer
    	nodePackages.pyright
    ];
    plugins = with pkgs.vimPlugins;  [
    	(plugin {repo="tpope/vim-sensible";})
    	(plugin {repo="tpope/vim-surround";})
    	(plugin {repo="rktjmp/hotpot.nvim";})
    	# (plugin {repo="stevearc/dressing.nvim";})
    	(plugin {repo="TimUntersberger/neogit";})
    	(plugin {repo="akinsho/git-conflict.nvim";})
    	(plugin {repo="simrat39/rust-tools.nvim";})
    	(plugin {repo="mfussenegger/nvim-jdtls";})
    	(plugin {repo="elihunter173/dirbuf.nvim";})
    	(plugin {repo="vmchale/dhall-vim";})
    	(plugin {repo="neovim/nvim-lspconfig";})
    	(plugin {repo="williamboman/nvim-lsp-installer";})
    	(plugin {repo="ms-jpq/chadtree";})
    	(plugin {repo="kyazdani42/nvim-web-devicons";})
    	(plugin {repo="hrsh7th/nvim-cmp";})
    	(plugin {repo="hrsh7th/cmp-nvim-lsp";})
    	(plugin {repo="dcampos/nvim-snippy";})
    	(plugin {repo="dcampos/cmp-snippy";})
    	(plugin {repo="honza/vim-snippets";})
    	(plugin {repo="hrsh7th/cmp-nvim-lsp-signature-help";})
    	(plugin {repo="nvim-treesitter/nvim-treesitter";})
    	(plugin {repo="nvim-treesitter/nvim-treesitter-textobjects";})
    	# (plugin {repo="b3nj5m1n/kommentary";})
    	(plugin {repo="unblevable/quick-scope";})
    	(plugin {repo="eraserhd/parinfer-rust";})
    	(plugin {repo="tpope/vim-fugitive";})
    	(plugin {repo="noib3/nvim-compleet";})
    	(plugin {repo="echasnovski/mini.nvim";})
    	# (plugin {repo="feline-nvim/feline.nvim";})
    	(plugin {repo="lewis6991/gitsigns.nvim";})
    	(plugin {repo="simrat39/symbols-outline.nvim";})
    	# (plugin {repo="j-hui/fidget.nvim";})
    	(plugin {repo="arrufat/vala.vim";})
    	(plugin {repo="nvim-lua/popup.nvim";})
    	(plugin {repo="nvim-lua/plenary.nvim";})
    	# (plugin {repo="jvgrootveld/telescope-zoxide";})
    	# (plugin {repo="nvim-telescope/telescope-ui-select.nvim";})
    	# (plugin {repo="nvim-telescope/telescope.nvim";})
    	# (plugin {repo="navarasu/onedark.nvim";})
    	(plugin {repo="Pocco81/DAPInstall.nvim";})
    	(plugin {repo="mfussenegger/nvim-dap";})
    	(plugin {repo="rcarriga/nvim-dap-ui";})
    	(plugin {repo="direnv/direnv.vim";})
    	(plugin {repo="christoomey/vim-tmux-navigator";})
    	# (plugin {repo="folke/trouble.nvim";})
    	(plugin {repo="kyazdani42/nvim-web-devicons";})
    	(plugin {repo="jose-elias-alvarez/null-ls.nvim";})
    	# (plugin {repo="glepnir/dashboard-nvim";})
        ];
  };
  # Generate a lua table that translates repos to nix store paths
  nix2Packer = neovim2.mkTranslationTable neovimConfig.plugins;
  in 
     neovimConfig // {
      configure = {
        customRC = " lua NIX_PLUGINS = require'${nix2Packer}' ";
        };
    }
  
