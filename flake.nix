{
	description = "NixOS flake";
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
		zen-browser = {
			url = "github:conneroisu/zen-browser-flake";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		home-manager = {
			url = "github:nix-community/home-manager/release-25.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		mac-style-plymouth = {
  	url = "github:SergioRibera/s4rchiso-plymouth-theme";
  	inputs.nixpkgs.follows = "nixpkgs";
};
	};
	outputs = {self, nixpkgs,zen-browser,mac-style-plymouth, ... }@inputs:
	let 
		system = "x86_64-linux";
		# in example
		pkgs = import nixpkgs {
			overlays = [ inputs.mac-style-plymouth.overlays.default ];
		};
		# in example
		# pkgs = import nixpkgs {
		# 	overlays = [ inputs.mac-style-plymouth.overlays.default ];
		# };
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
