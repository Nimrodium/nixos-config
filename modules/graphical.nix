{lib, config, inputs, pkgs, ...}:
let cfg = config.graphical; in {

  options.graphical = {
    enable = lib.mkEnableOption "Enable Nimmy Desktop Environment module";
    enableTouchscreen = lib.mkEnableOption "Enable touchscreen support";
  };

  config = lib.mkIf cfg.enable {
    fonts.packages = with pkgs; [
      nerd-fonts.symbols-only
      noto-fonts-cjk-sans
      font-awesome
    ];
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
      networkmanagerapplet
    ] ++ (lib.optionals cfg.enableTouchscreen [
      iio-hyprland
      iio-sensor-proxy
      wvkbd
      jq
    ]);

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
    # wayland.windowManager.hyprland = {
    #   settings = {
    #     "$mod" = "SUPER";
    #     bind = [
    #       "$mod, T, exec, kitty"
    #     ]
    #     ++ (builtins.concatLists (
    #       builtins.genList(i: let ws = 1+ 1; in [
    #         "$mod, code:1${toString i}, workspace, ${toString ws}"
    #         "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"]
    #             )
    #           9)
    #     );
    #   };
    # };
  };
}
