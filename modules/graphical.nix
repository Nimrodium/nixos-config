{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.graphical;
  # pkgs-unstable = inputs.hyprland.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{

  options.graphical = {
    enable = lib.mkEnableOption "Enable Nimmy Desktop Environment module";
    enableTouchscreen = lib.mkEnableOption "Enable touchscreen support";
    enableGreetd = lib.mkEnableOption "enable greetd";
  };

  config = lib.mkIf cfg.enable {
    fonts.packages = with pkgs; [
      nerd-fonts.symbols-only
      noto-fonts-cjk-sans
      font-awesome
    ];
    environment.systemPackages =
      with pkgs;
      [
        xfce.thunar
        kitty
        hyprpaper
        wofi
        waybar
        xdg-desktop-portal-wlr
        adwaita-icon-theme
        gnome-themes-extra
        hypridle
        hyprshot
        wvkbd
        swaynotificationcenter
        xfce.thunar
        eog
        # plasma5Packages.kdeconnect-kde
        networkmanagerapplet
        jq
      ]
      ++ (lib.optionals cfg.enableTouchscreen [
        iio-hyprland
        iio-sensor-proxy
        wvkbd
      ]);

    programs.hyprland = {
      withUWSM = true;
      enable = true;
      xwayland.enable = true;
      # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      # portalPackage =
      # inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
  };
}
