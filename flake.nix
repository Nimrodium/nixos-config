{
	description = "NixOS flake";
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
		home-manager = {
			url = "github:nix-community/home-manager/release-25.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};
	outputs = {self, nixpkgs, ... }@inputs: {
		nixosConfigurations = {
		linuxbook = nixpkgs.lib.nixosSystem {
			modules = [
				./configuration.nix
				inputs.home-manager.nixosModules.home-manager
			];
		};
		};
	};
}
