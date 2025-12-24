{
  options,
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
{
  # surface specific configuration
  imports = [
    ../../modules/nix.nix
    ./hardware-configuration.nix
    ../../modules/graphical.nix
    ../../modules/kyle-home.nix
    ../../modules/rpishare.nix
    ../../modules/packages.nix
  ];
  graphical.enable = true;
  graphical.enableGreetd = false;
  packages.enable = true;
  rpishare.enable = true;

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    plymouth = {
      enable = false;
      theme = "mac-style";
      themePackages = [ pkgs.mac-style-plymouth ];
    };
    initrd.systemd.enable = true;
    kernelParams = [
      # "quiet"
      # "splash"
      "boot.shell_on_fail"
      "udev.log_priorit"
      "i915.enable_psr=0"
    ];
    kernelPatches = [
      {
        name = "rust-1.91-fix";
        patch = ./rust-fix.patch;
      }
    ];
  };
  hardware = {
    microsoft-surface.kernelVersion = "stable";
    # microsoft-surface = {
    #   kernelVersion = "stable";

    #   # ipts.enable = true;
    #   # surface-control.enable = true;
    # };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  # microsoft-surface = {
  #   surface-control.enable = true;
  #   ipts.enable = true;
  # };
  services.iptsd.enable = true;
  environment.systemPackages = [ pkgs.surface-control ];
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = false;
  # services.udev.extraRules = ''SUBSYSTEM=="net", KERNEL=="wlp1s0", RUN+="/usr/sbin/iw dev $name set power_save off"'';
  # hardware.microsoft-surface.ipts.enable = true;
  # i have no idea how to import it
  # microsoft-surface.surface-control.enable = true;
  # microsoft-surface.kernelVersion = "surface-devel";

  services.logind = {
    lidSwitch = "suspend";
    powerKey = "suspend";
    powerKeyLongPress = "poweroff";
  };
  services.avahi = {
    enable = true;
  };
  # networking.hostName = "surface";
  # networking.networkmanager.enable = true;
  # networking.wireless.iwd.enable = true;
  # networking.networkmanager.wifi.backend = "iwd";
  # networking.networkmanager.wifi.powersave = false;
  # networking.wireless.iwd.settings = {
  #   IPv6 = {Enabled = true;};
  #   Settings = {AutoConnet = true;};
  # };
  networking = {
    hostName = "surface";
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
      wifi.powersave = false;
    };
    wireless = {
      iwd.enable = true;
      iwd.settings = {
        IPv6.Enabled = true;
        Settings.AutoConnet = true;
      };
    };
  };
  # networking.timeServers = options.networking.timeServers.default;
  services.ntp.enable = true;
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
    flatpak.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
  # to speed up build timetime
  documentation.man.generateCaches = false;
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
