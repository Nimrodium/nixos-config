{
  nixConfig = {
    allowUnfree = true;
    allowUnfreePackages = true;
  };
  description = "NixOS flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs-unstable.url = "github:/NixOS/nixpkgs/nixpkgs-unstable";
    zen-browser = {
      url = "github:conneroisu/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    mac-style-plymouth = {
      url = "github:Nimrodium/nixos-plymouth-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
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

    nixos-splash-plasma6 = {
      url = "github:nimrodium/nixos-splash-plasma6";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      zen-browser,
      mac-style-plymouth,
      nixos-hardware,
      ...
    }@inputs:
    let
      # forEachSystem =
      #   fn:
      #   nixpkgs.lib.genAttrs nixpkgs.lib.platforms.linux (
      #     system: fn nixpkgs.legacyPackages.${nixpkgs.hostPlatform.system}
      #   );
      x86_64_linux = "x86_64-linux";
      aarch64_linux = "aarch64-linux";
      # system = ;
      # system = "x86_64-linux";
      # in example
      pkgs = import nixpkgs {
        # inherit syste;
        # stdenv.hostPlatform.system = x86_64-linux;
        hostPlatform = pkgs.stdenv.hostPlatform;
        system = x86_64_linux;
        # hostPlatform = pkgs.hostPlatform;
        config.allowUnfree = true;
        config.allowUnfreePackages = true;
        # config.packageOverrides = pkgs: {
        #   rustc = pkgs.rust-bin.stable.latest.default;
        # };
        overlays = [
          inputs.mac-style-plymouth.overlays.default
          # (final: prev: {
          #   ytmdesktop = prev.ytmdesktop;
          # })
        ];
      };
      # in example
      # pkgs = import nixpkgs {
      # 	overlays = [ inputs.mac-style-plymouth.overlays.default ];
      # };
    in
    {
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          # nixpkgs.hostPlatform.system = x86_64-linux;
          inherit pkgs;
          system = x86_64_linux;

          specialArgs = { inherit inputs; };
          modules = [
            ./machines/desktop/desktop.nix
            inputs.home-manager.nixosModules.home-manager
          ];
        };
        iso = nixpkgs.lib.nixosSystem {
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix"
            "${nixpkgs}/modules/installer/cd-dvd/channel.nix"
            ./machines/iso/iso.nix
          ];
        };
        surface = nixpkgs.lib.nixosSystem {
          # inherit system pkgs;
          inherit pkgs;
          system = x86_64_linux;
          # system = pkgs.stdenv.hostPlatform.system;
          specialArgs = { inherit inputs; };
          modules = [
            ./machines/surface/surface.nix
            inputs.home-manager.nixosModules.home-manager
            nixos-hardware.nixosModules.microsoft-surface-common
            {
              nix.settings = {
              };
            }
          ];
        };
        linuxbook = nixpkgs.lib.nixosSystem {
          # inherit system pkgs;
          inherit pkgs;
          system = x86_64_linux;
          specialArgs = { inherit inputs; };
          modules = [
            ./machines/linuxbook/linuxbook.nix
            inputs.home-manager.nixosModules.home-manager
          ];
        };
      };
    };
}
