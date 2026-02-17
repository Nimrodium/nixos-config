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
  environment.systemPackages =
    with pkgs;
    [ ]
    ++ (with pkgs.gnomeExtensions; [
      blur-my-shell
      dash-to-panel
    ]);
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;
  programs.dconf.profiles.kyle.databases = [
    {
      settings = {
        "org/gnome/desktop/interface" = {
          accent-color = "blue";
        };
        "org/gnome/shell" = {
          enabled-extensions = with pkgs.gnomeExtensions; [
            blur-my-shell.extensionUuid
            dash-to-panel.extensionUuid
          ];
        };
      };
    }
  ];
  networking.hostName = "macbook";
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
