{ pkgs, lib, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
  shared = ../../modules/shared.nix;
  hm = ../../modules/shared.nix;
  packages = shared.config.environment.systemPackages;
  home = hm.users.kyle.home;
in
{

  # backupFileExtension = "kys-home-manager";
  home.username = "kyle";
  home.homeDirectory = "/home/kyle";
  stateVersion = "25.11";
  file = home.file;
  inherit packages;
}
