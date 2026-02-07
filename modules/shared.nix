{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
let
  # system = pkgs.stdenv.hostPlatform.system;
  cfg = config.shared;
  # sticky = inputs.sticky.packages.${system}.default;
  # zen-browser = inputs.zen-browser.packages.${system}.default;
  packages' =
    (import ./packages.nix {
      inherit pkgs lib inputs;
    }).packages';
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
    environment.systemPackages = packages' cfg.enableGraphical cfg.enableGaming;
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
