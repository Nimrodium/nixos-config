{lib, config, inputs, pkgs, ...}:
let cfg = config.packages; in {
  options.packages = {
    enable = lib.mkEnableOption "enable shared packages";
  };
  config = lib.mkIf cfg.enable {
    services.sshd.enable = true;
    environment.systemPackages = with pkgs; [
    		git
        wget

        # cli tools
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
        bluetui
        playerctl
        vlc

        tor
        torctl
        tor-browser
        torsocks
        darktable
    ];
    # for kde-connect
    networking.firewall.allowedTCPPortRanges = [
      { from = 1714; to = 1764; }
    ];

    networking.firewall.allowedUDPPortRanges = [
      { from = 1714; to = 1764; }
    ];
    programs = {
      java = {
        enable = true;
        binfmt = true;
      };
      adb.enable = true;
      firefox.enable = true;
      fish.enable = true;
      nix-ld.enable = true;
    };
  };
}
