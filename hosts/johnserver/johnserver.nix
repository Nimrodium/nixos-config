{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  shared = pkgs.callPackage ../../modules/shared.nix { inherit inputs; };
  # hm = pkgs.callPackage ../../modules/kyle-home.nix { inherit inputs; };
  packages =
    (import ../../modules/packages.nix {
      inherit pkgs lib;
      config = { };
    }).packages'
      false
      false;
  # home = hm.users.kyle.home;
in
{
  # backupFileExtension = "kys-home-manager";
  # file = home.file;

  home = {
    username = "kyle";
    homeDirectory = "/home/kyle";
    stateVersion = "25.11";
    inherit packages;
    file = {
      ".config/fastfetch".source = ../../config/fastfetch;
    };
  };
}
