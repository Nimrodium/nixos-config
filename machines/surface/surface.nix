{config, inputs, pkgs, ...}:
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
  packages.enable = true;
  rpishare.enable = true;
  boot = {
    loader.systemd-boot.enable =true;
    loader.efi.canTouchEfiVariables = true;
    plymouth = {
      enable = false;
      theme = "mac-style";
      themePackages = [ pkgs.mac-style-plymouth ];
    };
    initrd.systemd.enable=true;
    kernelParams = ["quiet" "splash" "boot.shell_on_fail" "udev.log_priorit"];
    };
    hardware = {
      bluetooth = {
        enable=true;
        powerOnBoot=true;
      };
  };
  networking.hostName = "surface";
  networking.networkmanager.enable = true;
  networking.wireless.iwd.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  time.timeZone = "America/Pacific";
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
  # to speed up build timetime
  documentation.man.generateCaches = false;
  users.users.kyle = {
    isNormalUser = true;
    description = "kyle";
    shell = pkgs.fish;
    extraGroups = ["wheel" "input"];
  };
  networking.wireless.iwd.settings = {
    IPv6 = {Enabled = true;};
    Settings = {AutoConnet = true;};
  };
}
