{ pkgs, lib, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
  shared = pkgs.callPackage ../../modules/shared.nix { };
  hm = pkgs.callPackage ../../modules/shared.nix { };
  packages = shared.config.environment.systemPackages;
  home = hm.users.kyle.home;
in
{

  # backupFileExtension = "kys-home-manager";
  home.username = "kyle";
  home.homeDirectory = "/home/kyle";
  home.stateVersion = "25.11";
  file = home.file;
  inherit packages;
}
