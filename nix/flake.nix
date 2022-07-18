{
  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
      nixvim.url  = "github:pta2002/nixvim";
      home-manager.url = "github:nix-community/home-manager";
    };
  outputs = { self, nixpkgs, nixvim, home-manager }:
  let 
      system = "x86_64-linux";
  in
  {
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
		./home.nix
	];
    };
  };
}
