{ config, pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  nix.settings.auto-optimise-store = true;
  networking.networkmanager.enable = true;
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.utf8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.utf8";
    LC_IDENTIFICATION = "pt_BR.utf8";
    LC_MEASUREMENT = "pt_BR.utf8";
    LC_MONETARY = "pt_BR.utf8";
    LC_NAME = "pt_BR.utf8";
    LC_NUMERIC = "pt_BR.utf8";
    LC_PAPER = "pt_BR.utf8";
    LC_TELEPHONE = "pt_BR.utf8";
    LC_TIME = "pt_BR.utf8";
  };
  services.zerotierone = {
    enable = true;
    joinNetworks = [
      "8850338390776f8a"
    ];
  };
  services.locate = {
    enable = true;
    locate = pkgs.mlocate;
    localuser = null;
  };
  
  services.openssh = {
    enable = true;
    ports  = [ 6534 ];
  };
  
  nix = {
      package = pkgs.nixFlakes;
    extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver = {
    layout = "br";
    xkbVariant = "";
  };
  console.keyMap = "br-abnt2";
  services.printing.enable = true;
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  users.users.diegovsky = {
    isNormalUser = true;
    description = "Diego Augusto Silva Castro";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJEhb1jCOfGYHZY/4IXUyqdox7uzPMaNbYsb5wNVv/j2 diego.augusto@protonmail.com"];
    shell = pkgs.zsh;
  };
  nixpkgs.config.allowUnfree = true;
  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    ripgrep
    fd
    git
    neovim
    tree
    home-manager
    zsh
    firefox
    tdesktop
    bat
  ];
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    fira-code
    (nerdfonts.override { fonts = ["FiraCode" ]; })
  ];
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  system.stateVersion = "22.05";
}
