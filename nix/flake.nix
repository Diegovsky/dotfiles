{
  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
      # nixvim.url  = "github:pta2002/nixvim";
      home-manager.url = "github:nix-community/home-manager";
      neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    };
  outputs = { self, nixpkgs, neovim-nightly, home-manager }:
  let 
      system = "x86_64-linux";
      overlays = [
        neovim-nightly.overlay
      ];
  in
  {
    /* inherit overlays; */
    nixosConfigurations.notenix = nixpkgs.lib.nixosSystem {
    	inherit system;
      modules = [
        ./configuration.nix
        ./notenix.nix
      ];
    };
    homeConfigurations."diegovsky" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
	modules = [
            ({ config, pkgs, ... }: { nixpkgs.overlays = overlays; })
		./home.nix
	];
    };
  };
}
