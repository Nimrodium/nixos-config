{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ../../modules/modules.nix
    ./hardware-configuration.nix
  ];
  definedUsers.kyle = true;
  kyle-home.enable = true;
  graphical.enable = false;
  graphical.enableTouchscreen = true;
  shared.enable = true;
  shared.enableKeyd = true;
  rpishare.enable = true;
  boot = {
    # extraModulePackages = [ config.boot.kernelPackages.wireguard ];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
    # shouldnt this be in hardware-configuration.nix ?
    initrd.luks.devices."luks-fa47f6fa-0c53-46a2-8f7b-e74327ebdc03".device =
      "/dev/disk/by-uuid/fa47f6fa-0c53-46a2-8f7b-e74327ebdc03";

  plymouth = {
    enable = false;
    # retainSplash = true;
    theme = "mac-style";
    themePackages = [ pkgs.mac-style-plymouth ];
    # themePackages = [pkgs.callPackage /home/kyle//nixos-plymouth-theme/src/mac-style];
  };

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    initrd.systemd.enable = true;
    kernelParams = [
      # "quiet"
      # "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    # loader.timeout = 0;

  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  networking.hostName = "linuxbook";
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
  networking.networkmanager.enable = true;
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
  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [ "/mnt/.btrfs_root_volume" ];
  };
  services.beesd.filesystems = {
    root = {
      spec = "/mnt/.btrfs_root_volume";
      hashTableSizeMB = 2048;
      verbosity = "crit";
      extraOptions = [
        "--loadavg-target"
        "5.0"
      ];
    };
  };
  # to speed up build timetime
  documentation.man.generateCaches = false;
  # environment.systemPackages = with pkgs; [ fish ];
  programs.fish.enable = true;
  users.users.test = {
    isNormalUser = true;
    password = "test";
  };
  # users.users.kyle = {
  #   isNormalUser = true;
  #   description = "kyle";
  #   shell = pkgs.fish;
  #   extraGroups = [
  #     "wheel"
  #     "input"
  #   ];
  # };
  system.stateVersion = "25.05";
}
