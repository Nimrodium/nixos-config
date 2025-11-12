{
	description = "NixOS flake";
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
		nixpkgs-unstable.url = "github:/NixOS/nixpkgs/nixpkgs-unstable";
		zen-browser = {
			url = "github:conneroisu/zen-browser-flake";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		home-manager = {
			url = "github:nix-community/home-manager/release-25.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		mac-style-plymouth = {
  	url = "github:Nimrodium/nixos-plymouth-theme";
  	inputs.nixpkgs.follows = "nixpkgs";
		};
		hyprland.url = "github:hyprwm/Hyprland";
		# hyprland-plugins = {
		# 	url = "github:hyprwm/hyprland-plugins";
		# 	inputs.hyprland.follows = "hyprland";
		# };
	  hyprgrass = {
       url = "github:horriblename/hyprgrass";
       inputs.hyprland.follows = "hyprland"; # IMPORTANT
    };
	  Hyprspace = {
      url = "github:KZDKM/Hyprspace";

      # Hyprspace uses latest Hyprland. We declare this to keep them in sync.
      inputs.hyprland.follows = "hyprland";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
	};
	outputs = {self, nixpkgs,zen-browser,mac-style-plymouth, nixos-hardware,... }@inputs:
	let
		system = "x86_64-linux";
		# in example
		pkgs = import nixpkgs {
			inherit system;
			config.allowUnfree = true;
			overlays = [ inputs.mac-style-plymouth.overlays.default ];
		};
		# in example
		# pkgs = import nixpkgs {
		# 	overlays = [ inputs.mac-style-plymouth.overlays.default ];
		# };
	in
	{
		nixosConfigurations = {
		    iso = nixpkgs.lib.nixosSystem {
						modules = [
  		        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix"
  						"${nixpkgs}/modules/installer/cd-dvd/channel.nix"
 						 ./machines/iso/iso.nix
		        ];
				};
		    surface = nixpkgs.lib.nixosSystem {
			    inherit system pkgs;
					specialArgs = { inherit inputs; };
					modules = [
					    ./machines/surface/surface.nix
					    inputs.home-manager.nixosModules.home-manager
							nixos-hardware.nixosModules.microsoft-surface-common
					];
				};
    		linuxbook = nixpkgs.lib.nixosSystem {
    			inherit system pkgs;
    			specialArgs = {inherit inputs; };
    			modules = [
    				./machines/linuxbook/linuxbook.nix
    				inputs.home-manager.nixosModules.home-manager
    			];
        };
   	  };
  };
}
