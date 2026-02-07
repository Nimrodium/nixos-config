{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  sticky = inputs.sticky.packages.${system}.default;
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
      helix
      btop
      # cli tools
      caligula
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
      restic-browser
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
      vesktop
      krita
    ])
    ++ (lib.optionals gaming [
      prismlauncher
      lutris
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
