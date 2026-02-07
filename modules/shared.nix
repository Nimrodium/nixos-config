{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  cfg = config.shared;
  sticky = inputs.sticky.packages.${system}.default;
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
    environment.variables = {
      EDITOR = "micro";
      VISUAL = "micro";
      NIXPKGS_ALLOW_UNFREE = 1;
    };
    security.lsm = lib.mkForce [ ]; # to fix distrobox SELinux error ?
    services.sshd.enable = true;
    environment.systemPackages =
      with pkgs;
      [
        git
        wget
        sticky
        # cli tools
        caligula
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
        tree
        #dev
        nixfmt-rfc-style
        nil
        hyprls

        # rust
        cargo
        rustfmt
        rust-analyzer
        rustc

        openjdk17-bootstrap # java
        # python314 # python
        uv
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
        (writeShellScriptBin "sync-notebook" ''
          # set -x
          noterepo="$HOME/Documents/Notebook"
          stamp=$(date +"%d/%m/%y %I:%M %p")
          msg="sync $stamp from $HOSTNAME"
          g="git -C ${"$\{noterepo}"}"
          $g pull && $g add "$noterepo/." && $g commit -m "$msg" && $g push && echo success! $msg
        '')
      ]
      ++ (lib.optionals cfg.enableGraphical [
        obsidian
        unstable.deskflow
        zed-editor
        tor-browser
        vlc
        kitty
        kdePackages.kcalc
        darktable
      ])
      ++ (lib.optionals cfg.enableGaming [
        prismlauncher
        lutris
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
    networking.firewall.allowedTCPPorts = [
      22
      80
      24800 # deskflow

    ];
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
      gamemode.enable = cfg.enableGaming;
      steam = {
        enable = cfg.enableGaming;
        remotePlay.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
      };

    };
    # networking.firewall.a
    virtualisation.vmVariant = {
      # virtualisation.sharedDirectories = {
      #   test = {
      #     source = "/home/kyle/.config";
      #     target = "/home/kyle/.config";
      #   };
      # };
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
