{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  sticky = inputs.sticky.packages.${system}.default;
  daisy = inputs.daisy.packages.${system}.default;
  zen-browser = inputs.zen-browser.packages.${system}.default;
in
{
  packages' =
    graphical: gaming:
    with pkgs;
    [
      git
      wget
      sticky
      daisy
      helix
      btop
      # cli tools
      caligula
      lsof
      zoxide
      acpi
      yazi
      gh
      bat
      ripgrep
      fd
      gdu
      fastfetch
      fish
      micro
      file
      sshfs
      rclone
      restic
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
      java-language-server
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
        G="git -C ${"$\{NOTEREPO}"}"
        $G pull && $G add "$NOTEREPO/." && $G commit -m "$MSG" && $G push && echo success! $MSG
      '')
    ]
    ++ (lib.optionals graphical [
      restic-browser
      obsidian
      unstable.deskflow
      zed-editor
      vscode
      tor-browser
      vlc
      kitty
      kdePackages.kcalc
      darktable
      zen-browser
      scrcpy
      unstable.ytmdesktop
      vesktop
      krita
    ])
    ++ (lib.optionals gaming [
      prismlauncher
      lutris
      beyond-all-reason
    ]);
  homePrograms = {
    git = {
      enable = true;
      settings = {
        user = {
          name = "nimrodium";
          email = "nimrodium@protonmail.com";
        };
      };
    };
    fish = {
      enable = true;
      plugins = [ ];
      interactiveShellInit = ''
        							zoxide init --cmd cd fish | source
        							set -g fish_greeting ""
        							fastfetch
        						'';
      shellAliases = {
        cf = "clear && fastfetch";
        raspi = "ssh -Y kyle@99.107.90.205 -p 9025";
        ls = "eza";
        # zed = "nix run nixpkgs-unstable#zed-editor";
        zed = "zeditor";
        # hx = "helix";
        edit = "ms-edit";
        ubuntu = "distrobox enter ubuntu-latest";
        # showgpu = "lspci -nnk | rg 28:00 -A 5";
        # windows = "virsh start win11-gpu-no-spice";
        # stopwindows = "virsh shutdown win11-gpu-no-spice";
        # soft-reboot = "sudo systemctl soft-reboot";
      };
    };
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/etc/nixos";
    };
  };
}
