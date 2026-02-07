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
    flake-utils.url = "github:numtide/flake-utils";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:conneroisu/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";

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
    sticky = {
      url = "github:nimrodium/sticky";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-style-plymouth = {
      url = "github:Nimrodium/nixos-plymouth-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kwin-effects-better-blur-dx = {
      url = "github:xarblu/kwin-effects-better-blur-dx";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };
  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      zen-browser,
      mac-style-plymouth,
      nixos-hardware,
      ...
    }@inputs:
    let

      x86_64_linux = "x86_64-linux";
      aarch64_linux = "aarch64-linux";
      system = x86_64_linux;
      unstable-overlay = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = 1;
        };
      };
      # pkgsUnstable = import nixpkgs-unstable { inherit system; };
      pkgs = import nixpkgs {

        hostPlatform = pkgs.stdenv.hostPlatform;
        system = x86_64_linux;
        config.allowUnfree = true;
        config.allowUnfreePackages = true;
        overlays = [
          inputs.mac-style-plymouth.overlays.default
          unstable-overlay
        ];
      };
    in
    {
      homeConfigurations."kyle" = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./hosts/johnserver/johnserver.nix ];
        extraSpecialArgs = { inherit inputs; };
      };
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          inherit pkgs;
          system = x86_64_linux;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/desktop/desktop.nix
            inputs.home-manager.nixosModules.home-manager
            inputs.sops-nix.nixosModules.sops
          ];
        };
        surface = nixpkgs.lib.nixosSystem {
          inherit pkgs;
          system = x86_64_linux;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/surface/surface.nix
            inputs.home-manager.nixosModules.home-manager
            nixos-hardware.nixosModules.microsoft-surface-common
            inputs.sops-nix.nixosModules.sops
          ];
        };
        # macbook = nixpkgs.lib.nixosSystem {
        #   inherit pkgs;
        #   system = x86_64_linux;
        #   specialArgs = { inherit inputs; };
        #   modules = [
        #     ./hosts/macbook/macbook.nix
        #     inputs.home-manager.nixosModules.home-manager
        #   ];
        # };
        linuxbook = nixpkgs.lib.nixosSystem {
          inherit pkgs;
          system = x86_64_linux;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/linuxbook/linuxbook.nix
            inputs.home-manager.nixosModules.home-manager
            inputs.sops-nix.nixosModules.sops
          ];
        };
      };
    };
}
