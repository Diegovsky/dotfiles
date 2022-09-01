{config, pkgs, ...}:

{
  home.username = "diegovsky";
  home.homeDirectory = "/home/diegovsky";
  
  home.packages = with pkgs; [
    stow
    exa
    ripgrep
    fd
    zoxide
    direnv
    wl-clipboard
    wl-clipboard-x11
    # zsh plugins etc
    nix-zsh-completions
    zsh-syntax-highlighting
    zsh-completions
    # dev stuff
    python3
    rustup
    clang-tools
    luajit
    gdb
    ];
  programs.home-manager.enable = true;
  home.stateVersion = "22.05";

  # programs.nixvim = {
  # 	plugins.packer.enable = true;
  #       extraPlugins = [];
  #       colorscheme = "onedark";
  # };

  programs.zsh = {
    enable = true;
    envExtra =
      ''
      export PRIVATE_CONFIG_PREFIX="$HOME/dotfiles/user/zsh/"
      source "$PRIVATE_CONFIG_PREFIX/dot-zshenv"
      export ZDOTDIR="$PRIVATE_CONFIG_PREFIX/.config/zsh/"
      export IS_NIX=1
      '';
    # initExtra =
    # ''
    # source $PRIVATE_CONFIG_PREFIX/zshrc
    # '';
  };
  programs.neovim = {
    package = pkgs.neovim-nightly;
    enable = true;
    extraPackages = with pkgs; [
        sumneko-lua-language-server
        rust-analyzer
        pyright
        gopls
        # Tree sitter stuff
        tree-sitter
        tree-sitter-grammars.tree-sitter-bash
        tree-sitter-grammars.tree-sitter-c
        tree-sitter-grammars.tree-sitter-cmake
        tree-sitter-grammars.tree-sitter-commonlisp
        tree-sitter-grammars.tree-sitter-cpp
        tree-sitter-grammars.tree-sitter-css
        tree-sitter-grammars.tree-sitter-dart
        tree-sitter-grammars.tree-sitter-dockerfile
        tree-sitter-grammars.tree-sitter-glsl
        tree-sitter-grammars.tree-sitter-go
        tree-sitter-grammars.tree-sitter-gomod
        tree-sitter-grammars.tree-sitter-html
        tree-sitter-grammars.tree-sitter-java
        tree-sitter-grammars.tree-sitter-javascript
        tree-sitter-grammars.tree-sitter-json
        tree-sitter-grammars.tree-sitter-json5
        tree-sitter-grammars.tree-sitter-latex
        tree-sitter-grammars.tree-sitter-lua
        tree-sitter-grammars.tree-sitter-make
        tree-sitter-grammars.tree-sitter-markdown
        tree-sitter-grammars.tree-sitter-nix
        tree-sitter-grammars.tree-sitter-php
        tree-sitter-grammars.tree-sitter-python
        tree-sitter-grammars.tree-sitter-ruby
        tree-sitter-grammars.tree-sitter-rust
        tree-sitter-grammars.tree-sitter-toml
        tree-sitter-grammars.tree-sitter-vim
        tree-sitter-grammars.tree-sitter-zig
    ];
    extraConfig =
    ''
    packadd packer.nvim
    lua<<EOF
    NVIM_CONFIG_FOLDER=os.getenv("HOME")..'/dotfiles/user/nvim/.config/nvim/'
    package.path = NVIM_CONFIG_FOLDER..'lua/?.lua;'..package.path
    package.path = NVIM_CONFIG_FOLDER..'lua/?/init.lua;'..package.path
    require'packer'.init()
    NVIM_IS_NIX=true
    dofile(NVIM_CONFIG_FOLDER..'init.lua')
    EOF
    '';
    plugins = with pkgs.vimPlugins; [ packer-nvim ];
  };
}
