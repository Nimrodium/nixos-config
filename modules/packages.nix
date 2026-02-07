{
  pkgs,
  config,
  lib,
  ...
}:
{
  packages' =
    graphical: gaming:
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
      gdu
      fastfetch
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
        NOTEREPO="$HOME/Documents/Notebook"
        STAMP=$(date +"%d/%m/%y %I:%M %p")
        MSG="sync $STAMP from $HOSTNAME"
        g="git -C ${"$\{noterepo}"}"
        $g pull && $g add "$NOTEREPO/." && $g commit -m "$msg" && $g push && echo success! $msg
      '')
    ]
    ++ (lib.optionals graphical [
      obsidian
      unstable.deskflow
      zed-editor
      tor-browser
      vlc
      kitty
      kdePackages.kcalc
      darktable
      zen-browser
      scrcpy
      ytmdesktop
      krita
    ])
    ++ (lib.optionals gaming [
      prismlauncher
      lutris
    ]);
}
