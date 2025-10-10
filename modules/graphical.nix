# { lib, config, inputs, pkgs, ... }:

# let
#   cfg = config.DE;
# in
# {
#   imports = [];

#   options.DE = {
#     enable = lib.mkEnableOption "Enable Nimmy Desktop Environment module";
#     enableTouchscreen = lib.mkEnableOption "Enable touchscreen support (iio-hyprland and wvkbd)";
#     # wallpaper
#     # hyprland config will eventually be defined here in nix syntax.
#     # autologin
#     # autologin user
#   };

#   config = lib.mkIf cfg.enable (let
#     hyprlandBin = "${pkgs.hyprland}/bin/hyprland";
#   in {
#     environment.systemPackages = with pkgs; [
#       xfce.thunar
#       kitty
#       chromiuma
#       hyprpaper
#       wofi
#       waybar
#       xdg-desktop-portal-wlr
#       adwaita-icon-theme
#       gnome-themes-extra
#       hypridle
#       hyprshot
#       wvkbd
#       swaynotificationcenter
#       eog
#       plasma5Packages.kdeconnect-kde
#     ] ++ (lib.optional cfg.enableTouchscreen [
#       iio-hyprland
#       iio-sensor-proxy
#       wvkbd
#       jq
#     ]);

    # services.greetd = {
    #   enable = true;
    #   settings = {
    #     initial_session = {
    #       command = hyprlandBin;
    #       user = "kyle";
    #     };
    #     default_session = initial_session;
    #   };
    # };

#     services.pulseaudio.enable = false;
#     security.rtkit.enable = true;
#     security.polkit.enable = true;

#     services.pipewire = {
#       enable = true;
#       alsa.enable = true;
#       alsa.support32Bit = true;
#       pulse.enable = true;
#     };

    # programs.hyprland = {
    #   withUWSM = true;
    #   enable = true;
    #   xwayland.enable = true;
    #   package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    #   portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    # };

#     programs.iio-hyprland.enable = true;
#   });
# }

{lib, config, inputs, pkgs, ...}:
let cfg = config.graphical; in {

  options.graphical = {
    enable = lib.mkEnableOption "Enable Nimmy Desktop Environment module";
    enableTouchscreen = lib.mkEnableOption "Enable touchscreen support";
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      xfce.thunar
      kitty
      chromium
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
      plasma5Packages.kdeconnect-kde
    ] ++ (lib.optionals cfg.enableTouchscreen [
      iio-hyprland
      iio-sensor-proxy
      wvkbd
      jq
    ]);

    # services.greetd = rec {
    #   enable = true;
    #   settings = {
    #     initial_session = {
    #       command = "${pkgs.hyprland}/bin/hyprland";
    #       user = "kyle";
    #     };
    #     default_session = initial_session;
    #   };
    # };
    # services.greetd = rec {
    # enable = true;
    # settings.initial_session = {
    #   command = "${pkgs.hyprland}/bin/hyprland";
    #   user = "kyle";
    # };
    # settings.default_session = {
    #   command = "${pkgs.hyprland}/bin/hyprland";
    #   user = "kyle";
    # };  # now this works
# };

    # programs = {
    #   hyprland = {
    #     enable = true;
    #     xwayland.enable = true;
    #     package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    #     portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    #   };
    #   iio-hyprland.enable = true;
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

    programs.hyprland = {
      withUWSM = true;
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
  };
}
