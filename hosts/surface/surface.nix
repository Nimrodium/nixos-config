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
    ../../modules/modules.nix
    ./hardware-configuration.nix
    ./restart-iwd.nix
  ];
  restartIwd.enable = true;
  graphical.enable = true;
  graphical.enableGreetd = false;
  shared.enable = true;
  shared.enableGaming = true;
  shared.enableGraphical = true;
  shared.enableKeyd = true;
  rpishare.enable = true;
  kyle-home.enable = true;
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
      # {
      #   name = "rust-1.91-fix";
      #   patch = ./rust-fix.patch;
      # }
    ];
  };
  hardware = {
    microsoft-surface.kernelVersion = "stable";
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

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

  services.iptsd.enable = true;
  environment.systemPackages =
    with pkgs;
    [ surface-control ]
    ++ (with pkgs.gnomeExtensions; [
      blur-my-shell
      dash-to-panel
    ]);
  # services.desktopManager.cosmic.enable = true;
  # services.displayManager.cosmic-greeter.enable = false;
  services = {
    logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandlePowerKey = "suspend";
      HandlePowerKeyLongPress = "poweroff";
    };
    ntp.enable = true;
    keyd = {
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
    flatpak.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

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
  system.stateVersion = "25.05";
}
