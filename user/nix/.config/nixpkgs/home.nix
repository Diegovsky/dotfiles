{config, pkgs, ...}:

{
  home.username = "diegovsky";
  home.homeDirectory = "/home/diegovsky";
  
  home.packages = with pkgs; [
    stow
    exa
    zoxide
    direnv
    # zsh plugins etc
    nix-zsh-completions
    zsh-completions
    ];
  # programs.home-manager.enable = true;
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
      '';
    # initExtra =
    # ''
    # source $PRIVATE_CONFIG_PREFIX/zshrc
    # '';
  };
  programs.neovim = {
    enable = true;
    extraConfig =
    ''
    packadd packer.nvim
    lua<<EOF
    NVIM_CONFIG_FOLDER=os.getenv("HOME")..'/dotfiles/user/nvim/.config/nvim/'
    package.path = NVIM_CONFIG_FOLDER..'lua/?.lua;'..package.path
    package.path = NVIM_CONFIG_FOLDER..'lua/?/init.lua;'..package.path
    require'packer'.init()
    dofile(NVIM_CONFIG_FOLDER..'init.lua')
    EOF
    '';
    plugins = with pkgs.vimPlugins; [ packer-nvim ];
  };
  #programs.neovim = (import ./my-neovim.nix { inherit config pkgs; lib=pkgs.lib; });  
}
