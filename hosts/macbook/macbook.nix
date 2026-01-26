{ pkgs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  imports = [
    ../../modules/modules.nix
    # ./hardware-configuration.nix
  ];
  shared.enable = true;
  definedUsers.clara = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.systemd.enable = true;
    kernelParams = [
      "boot.shell_on_fail"
      "udev.log_priorit"
    ];

  };
  environment.systemPackages = with pkgs; [ ];
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;
  networking.hostname = "macbook";
  services = {

    flatpak.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
  system.stateVersion = "25.11";
}
