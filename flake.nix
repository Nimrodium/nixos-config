{
	description = "NixOS flake";
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
		zen-browser.url = "github:conneroisu/zen-browser-flake";
		home-manager = {
			url = "github:nix-community/home-manager/release-25.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};
	outputs = {self, nixpkgs,zen-browser, ... }@inputs: let 
		system = "x86_64-linux";
		pkgs = nixpkgs.legacyPackages.${system};
	in
	{
		nixosConfigurations = {
		linuxbook = nixpkgs.lib.nixosSystem {
			specialArgs = {inherit inputs; };
			modules = [
				./configuration.nix
				inputs.home-manager.nixosModules.home-manager
			];
		};
   	};
  };
}
