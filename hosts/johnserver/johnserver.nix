{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  # shared = pkgs.callPackage ../../modules/shared.nix { inherit inputs; };
  # hm = pkgs.callPackage ../../modules/kyle-home.nix { inherit inputs; };
  system = pkgs.stdenv.hostPlatform.system;
  idkwhattocallthis = (
    import ../../modules/packages.nix {
      inherit pkgs lib inputs;
    }
  );
  packages = (idkwhattocallthis.packages' false false) ++ (with pkgs; [ ]);
  homePrograms = idkwhattocallthis.homePrograms;
  # home
in
{
  # backupFileExtension = "kys-home-manager";
  # file = home.file;

  home = {
    sessionVariables = {
      TERM = "xterm";
    };
    username = "kyle";
    homeDirectory = "/home/kyle";
    stateVersion = "25.11";
    packages = (packages ++ (with pkgs; [ home-manager ]));
    file = {
      ".config/fastfetch".source = ../../config/fastfetch;
    };
  };

  programs = homePrograms // {

    ssh = {
      enableDefaultConfig = false;
      enable = true;
      matchBlocks = {
        surface = {
          hostname = "localhost";
          user = "kyle";
          port = 8022;
        };
      };
    };

  };
}
