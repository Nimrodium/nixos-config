{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  nixos-splash-plasma6 = inputs.nixos-splash-plasma6.packages.${pkgs.system}.default;
in
{
  imports = [
    ../../modules/modules.nix
    ./hardware-configuration.nix
  ];
  packages.enable = true;
  rpishare.enable = true;
  kyle-home.enable = true;
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.systemd.enable = true;
    kernelParams = [
      "boot.shell_on_fail"
      "udev.log_priorit"
    ];

  };
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  # system packages for desktop
  environment.systemPackages = with pkgs; [
    virt-manager
    qemu
    darkly
    darkly-qt5
    nixos-splash-plasma6
    libsForQt5.qtstyleplugin-kvantum
    inputs.kwin-effects-better-blur-dx.packages.${pkgs.system}.default # Wayland
  ];
  qt.platformTheme = "kde";
  services.desktopManager.plasma6.enable = true;
  services.desktopManager.cosmic.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  networking = {
    hostName = "desktop";
    networkmanager.enable = true;
  };
  # services.ntp.enable = true;
  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "backspace";
          };
        };
      };
    };
  };
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
  # users.groups.keyd = {};
  users.users.kyle = {
    isNormalUser = true;
    description = "kyle";
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "input"
      "networkmanager"
    ];
  };
  hardware.xone.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
}
