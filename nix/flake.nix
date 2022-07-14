{
  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    };
  outputs = { self, nixpkgs }:
  {
    nixosConfigurations.notenix = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        ./notenix.nix
      ];
    };
  };
}
