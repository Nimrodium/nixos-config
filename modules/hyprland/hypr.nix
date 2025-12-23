{config,lib,pkgs,...}:
let
  mkOutput = name: args: {
    inherit name;
    config = {
      criteria = name;
      status = "enable";
      mode = null;
      position = null;
      scale = 1.0;
      transform = "normal";
    } // args;
  };
  surfaceMonitor = mkOutput "eDP-1" { };
  # linuxbookMonitor = mkOutput ""
in {
  imports = [];
  home.packages = with pkgs; [
    waybar
    swww
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    systemdIntegration = true;
    config = {
      monitor = [
        "${surfaceMonitor.name}, 2000x3000, 0x0, 1"
      ];
    };
    settings = {

    };

    extraConfig = ''
      source=./config/apps.conf
      source=./config/colors.conf
      source=./config/env.conf
      source=./config/hyprgrass.conf
      source=./config/hyprspace.conf
      source=./config/general.conf
      source=./config/rules.conf
      source=./config/exec.conf
    '';
  };
}
