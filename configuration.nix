# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./home.nix
    ];
	
  # Bootloader.
  

  # Use latest kernel.

  boot = { 
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.luks.devices."luks-fa47f6fa-0c53-46a2-8f7b-e74327ebdc03".device = "/dev/disk/by-uuid/fa47f6fa-0c53-46a2-8f7b-e74327ebdc03";
  
  plymouth = {
    enable = true;
    theme = "mac-style";
    themePackages = [ pkgs.mac-style-plymouth ];
    # themePackages = [pkgs.callPackage /home/kyle//nixos-plymouth-theme/src/mac-style];
  };

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    initrd.systemd.enable = true;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    # loader.timeout = 0;

  };
  networking.hostName = "linuxbook"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  
  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
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
  					rightshift = "enter";
  				};
  			};
  		};
  	};
  };
  services.xserver = {
  # Enable the X11 windowing system.
  	  enable = true;
  	
  	  # # Enable the GNOME Desktop Environment.
  	  # displayManager.gdm.enable = true;
  	  # desktopManager.gnome.enable = true;
  	  # displayManager.sddm.enable = true;
  	  # Configure keymap in X11
  	  xkb = {
  	    layout = "us";
  		options = "grp:alt_shift_toggle";
  	    variant = "dvorak";
  	  };	
  };
  
  # Enable CUPS to print documents.
  services.printing.enable = true;
  # services.displayManager.autologin = {
  	# enable = true;
  	
  # };
  services.greetd =
  let 
	hyprland = "${pkgs.hyprland}/bin/hyprland";
	
  in {
  	enable = true;
  	settings = rec {
  		initial_session = {
  			command = "${hyprland}";
  			user = "kyle";
  		};
  		default_session = initial_session;
  	};
  };
  # services.swaync = {
  #   enable = true;
  # };
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  security.polkit.enable = true;
  # services.hypridle = {
  #   enable = true;
  # };
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # define system

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kyle = {
    isNormalUser = true;
    description = "kyle";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" "input" ];
    packages = with pkgs; [
	# zeditor
    ];
  };

  # Install firefox.
  # programs.firefox.enable = true;
  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    java = {
      enable = true;
      binfmt = true;
    };
    adb.enable = true;
    firefox.enable = false;	
    fish.enable = true;
    iio-hyprland.enable = true;
  };
  # Allow unfree packages
  # nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
    noto-fonts-cjk-sans
    font-awesome
  ];
  environment = {
	systemPackages = with pkgs; [
    fish
    git
    wget
    micro
    nixfmt-rfc-style
    nil
    hyprls
    ripgrep
    cargo # rust
    openjdk17-bootstrap # java
    python314 # python
    
    #hyprland
    hyprpaper
    wofi
    waybar
    eww
    podman
    pavucontrol
    blueman
    xdg-desktop-portal-wlr
    adwaita-icon-theme
    gnome-themes-extra
    brightnessctl
    hypridle
    pamixer

    hyprlandPlugins.hyprgrass
    hyprlandPlugins.hyprspace
    iio-hyprland
    # jq,iio-sensor-proxy required for iio-hyprland
    iio-sensor-proxy
	  jq 
	# --
	  xfce.thunar
    hyprshot
    eog
	file
	plasma5Packages.kdeconnect-kde
	swaynotificationcenter
  ];
  
	variables = {
		EDITOR = "micro";
    GTK_THEME = "Adwaita-dark";
	  };
  };
#  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  #];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.05"; # Did you read the comment?
}
