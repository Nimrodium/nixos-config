{
  nixConfig = {
    allowUnfree = true;
    allowUnfreePackages = true;
  };
  description = "NixOS flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
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
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    # hyprland-plugins = {
    # 	url = "github:hyprwm/hyprland-plugins";
    # 	inputs.hyprland.follows = "hyprland";
    # };
    # hyprgrass = {
    #   url = "github:horriblename/hyprgrass";
    #   inputs.hyprland.follows = "hyprland"; # IMPORTANT
    # };
    # Hyprspace = {
    #   url = "github:KZDKM/Hyprspace";

    #   # Hyprspace uses latest Hyprland. We declare this to keep them in sync.
    #   inputs.hyprland.follows = "hyprland";
    # };

    nixos-splash-plasma6 = {
      url = "github:nimrodium/nixos-splash-plasma6";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sticky = {
      url = "github:nimrodium/sticky";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    daisy = {
      url = "github:nimrodium/daisy";
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
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };
  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixos-hardware,
      flake-utils,
      ...
    }@inputs:
    let
      _pkg =
        pkg: system: overlays:
        import pkg {
          inherit system overlays;
          config.allowUnfree = true;
          config.permittedInsecurePackages = [
            "pnpm-10.29.2"
          ];
        };
      unstable-overlay = system: final: prev: {
        unstable = _pkg nixpkgs-unstable system [ ];
      };
      lix-overlay = final: prev: {
        inherit (prev.lixPackageSets.stable)
          nixpkgs-review
          nix-eval-jobs
          nix-fast-build
          colmena
          ;
      };
      pkgs =
        system:
        _pkg nixpkgs system [
          (unstable-overlay system)
          lix-overlay
        ];

      defineSystem =
        name: system: extraModules:
        let
          conf = ./hosts/${name}/${name}.nix;
        in
        nixpkgs.lib.nixosSystem {
          pkgs = pkgs system;
          inherit system;
          modules = [ conf ] ++ extraModules;
          specialArgs = { inherit inputs; };
        };
      defineHome =
        system:
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs system;
          modules = [ ./hosts/home/home.nix ];
          extraSpecialArgs = { inherit inputs; };
        };
      x86_64-linux = flake-utils.lib.system.x86_64-linux;
      aarch64-linux = flake-utils.lib.system.aarch64-linux;
      homeModule = inputs.home-manager.nixosModules.home-manager;
    in
    {
      homeConfigurations = {
        "kyle@bomb" = defineHome x86_64-linux;
        "kyle@raspi" = defineHome aarch64-linux;
      };
      nixosConfigurations = {
        desktop = defineSystem "desktop" x86_64-linux [ homeModule ];
        precision = defineSystem "precision" x86_64-linux [ homeModule ];
        surface = defineSystem "surface" x86_64-linux [
          homeModule
          inputs.nix-flatpak.nixosModules.nix-flatpak
          # nixos-hardware.nixosModules.microsoft-surface-common
        ];
        linuxbook = defineSystem "linuxbook" x86_64-linux [ homeModule ];
      };
    };
}
