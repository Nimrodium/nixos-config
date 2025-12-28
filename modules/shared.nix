{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.shared;
in
{
  options.shared = {
    enable = lib.mkEnableOption "enable shared configuration";
    enableGraphical = lib.mkEnableOption "enable gui packages";
    enableAdditional = lib.mkEnableOption "enable additional packages";
    enableGaming = lib.mkEnableOption "enable packages for gaming";
    enableKeyd = lib.mkEnableOption "enable keyd mapping";
  };
  config = lib.mkIf cfg.enable {
    security.lsm = lib.mkForce [ ]; # to fix distrobox SELinux error ?
    services.sshd.enable = true;
    environment.systemPackages =
      with pkgs;
      [
        git
        wget

        # cli tools
        zoxide
        acpi
        yazi
        gh
        ripgrep
        fd
        fish
        micro
        file
        sshfs
        rclone
        #dev
        nixfmt-rfc-style
        nil
        hyprls
        cargo # rust
        openjdk17-bootstrap # java
        python314 # python
        clang
        haskell-language-server
        ghc
        nixd
        package-version-server
        # - utilities - #
        podman
        pavucontrol
        blueman
        brightnessctl
        pamixer
        wl-clipboard
        playerctl
        bluetuith
        tor
        torctl

        torsocks

        fastfetch
        eza
        nh

      ]
      ++ (lib.optionals cfg.enableGraphical [
        zed-editor
        tor-browser
        vlc
        kitty
        kdePackages.kcalc
        darktable
      ]);
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      nssmdns6 = true;
    };
    services.keyd = lib.mkIf cfg.enableKeyd {
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
    # programs = lib.mkIf cfg.enableAdditional {
    #   steam = {};
    # };
    programs = {
      fish.enable = true;
      nix-ld.enable = true;
      adb.enable = true;
      java = {
        enable = true;
        binfmt = true;
      };
      kdeconnect.enable = cfg.enableGraphical;
      firefox.enable = cfg.enableGraphical;
      steam = {
        enable = cfg.enableGaming;
        remotePlay.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
      };
    };

    virtualisation.vmVariant = {
      virtualisation.sharedDirectories = {
        test = {
          source = "/home/kyle/.config";
          target = "/home/kyle/.config";
        };
      };
      virtualisation.qemu.options = [
        "-device virtio-vga-gl"
        "-display gtk,gl=on,show-cursor=off"
        # Wire up pipewire audio
        "-audiodev pipewire,id=audio0"
        "-device intel-hda"
        "-device hda-output,audiodev=audio0"
        "-m 6G"
      ];
      # virtualisation
      environment.sessionVariables = lib.mkVMOverride {
        WLR_NO_HARDWARE_CURSORS = "1";
      };
    };
    hardware.xone.enable = cfg.enableGaming;
  };
}
