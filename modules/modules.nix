{ pkgs, lib, ... }:
{
  imports = [
    # ./apps.nix
    # ./distributedbuilds.nix
    # ./hyprland
    ./packages.nix
    ./rpishare.nix
    # ./consoleUser.nix
    ./graphical.nix
    ./kyle-home.nix
    ./nix.nix
    # ./remotebuilders.nix
    # ./shared.nix
  ];
}
