{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  nixos-splash-plasma6 = inputs.nixos-splash-plasma6.packages.${system}.default.override {
    splashText = "Fully Functional System";
  };
  kwin-better-blur-dx = inputs.kwin-effects-better-blur-dx.packages.${system}.default;
in
{
  imports = [
    ../../modules/modules.nix
    ./hardware-configuration.nix
  ];
  graphical.enable = false;
  shared.enable = true;
  shared.enableGraphical = true;
  shared.enableGaming = true;
  shared.enableKeyd = true;
  rpishare.enable = true;
  kyle-home.enable = true;
  definedUsers.kyle = true;
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
    # darkly-qt5
    nixos-splash-plasma6
    # libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum
    kwin-better-blur-dx
    # unstable.winboat
    unstable.freerdp
    maliit-keyboard
    radeontop
  ];
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu = {
    swtpm.enable = true;
  };
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.waydroid = {
    enable = true;
    package = pkgs.waydroid-nftables;
  };

  qt.platformTheme = "kde";
  services.desktopManager.plasma6.enable = true;
  services.desktopManager.cosmic.enable = false;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  networking = {
    hostName = "desktop";
    networkmanager.enable = true;
    hosts."192.168.1.159" = [ "louiscloud.duckdns.org" ];

    nat = {
      enable = true;
      externalInterface = "wlp34s0";
      internalInterfaces = [ "eno1" ];
    };
    interfaces."eno1" = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "10.0.0.1";
          prefixLength = 24;
        }
      ];
    };
    firewall.allowedUDPPorts = [
      53
      67
    ];
  };
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
  services = {

    flatpak.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
  services.github-runners = {
    desktop = {
      enable = true;
      tokenFile = "/home/kyle/secrets/github-token";
      # workDir = "~/.github-actions";
      user = "kyle";
      url = "https://github.com/nimrodium/nixos-config";
    };
  };
  system.stateVersion = "25.05";
}
