{config, pkgs, ...}:

{
  home.username = "diegovsky";
  home.homeDirectory = "/home/diegovsky";
  
  home.packages = with pkgs; [
    stow
    exa
    zoxide
    direnv
    ];
  # programs.home-manager.enable = true;
  home.stateVersion = "22.05";

  programs.zsh = {
    enable = true;
    initExtra = ''
          source ~/.zshenv
          if [[ -f /etc/profile ]]; then
            source /etc/profile
          fi
        '';
  };
  programs.neovim = (import ./my-neovim.nix { inherit config pkgs; lib=pkgs.lib; });  
}
