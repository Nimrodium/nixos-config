{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  # home-manager = inputs.home-manager;
  homePrograms =
    (import ./packages.nix {
      inherit pkgs lib;
      config = { };
    }).homePrograms;
  cfg = config.kyle-home;
in
{
  options.kyle-home = {
    enable = lib.mkEnableOption "enable kyle home";
    enableGraphical = lib.mkEnableOption "enable graphical home settings";
  };
  config = lib.mkIf cfg.enable {
    home-manager = {
      backupFileExtension = "ihatehm";

      users.kyle = {
        wayland.windowManager.hyprland = {
          enable = cfg.enableGraphical;
          plugins = [
            pkgs.hyprlandPlugins.hyprspace
            pkgs.hyprlandPlugins.hyprgrass
          ];
        };
        services = {
          podman = {
            enable = true;
          };
        };
        home = {
          stateVersion = "25.05";

          file = {
            ".wallpapers/".source = ../wallpapers;
            ".config/waybar/".source = ../config/waybar;
            ".config/hypr/".source = ../config/hypr;
            ".config/fastfetch".source = ../config/fastfetch;
            ".config/wofi".source = ../config/wofi;
            ".config/waybar".source = ../config/waybar;
            ".config/rofi".source = ../config/rofi;
            ".config/wlogout".source = ../config/wlogout;

            ".config/scripts/hyprland_load_plugins.sh" = {
              text = ''
                #!/usr/bin/env bash
                function errnot { hyprctl notify 3 200 0 "failed to load $1"; exit 1; }
                hyprctl plugins load ${pkgs.hyprlandPlugins.hyprspace}/lib/libhyprspace.so || errnot "hyprspace"
                hyprctl plugins load ${pkgs.hyprlandPlugins.hyprgrass}/lib/libhyprgrass.so || errnot "hyprgrass"
                hyprctl notify 1 200 0 "plugins loaded"
                				'';
              executable = true;
            };
          };
          packages = with pkgs; [
            # inconsolata
            # source-code-pro
          ];
        };
        xdg.portal = {
          enable = lib.mkIf cfg.enableGraphical;
          extraPortals = with pkgs; [
            kdePackages.xdg-desktop-portal-kde
            xdg-desktop-portal-hyprland
            # xdg-desktop-portal-cosmic
            xdg-desktop-portal-gnome
          ];
        };
        programs = homePrograms // {
          nix-index = {
            enable = true;
            enableFishIntegration = true;
          };
          # gtk.enable = true;
          home-manager.enable = true;
          chromium.enable = true;
          wlogout = {
            enable = true;
            layout = [
              {
                label = "shutdown";
                action = "systemctl poweroff";
                text = "Shutdown";
                keybind = "s";
              }
            ];
          };
          helix = {
            enable = true;
            languages = {
              language = [
                {
                  name = "rust";
                }
              ];
            };
            settings = {
              theme = "autumn-night";
            };
          };
          eza.enable = true;
          btop.enable = true;
          bat.enable = true;
          kitty = {
            enable = true;
            themeFile = "Tomorrow_Night_Bright";
            font = {
              name = "source code pro";
              size = 11.0;
            };
            settings = {
              shell = "${pkgs.fish}/bin/fish";
              cursor_shape = "block";
              open_url_with = "zen-browser"; # browser
              detect_urls = "yes";
              underline_hyperlinks = "never";
              sync_to_monitor = "never";
              window_padding_width = 5;
              single_window_padding_width = -1;
              tab_bar_edge = "bottom";
              tab_bar_margin_width = 5.0;
              tab_bar_margin_height = 2.0;
              tab_bar_style = "powerline";
              tab_bar_align = "left";
              tab_bar_min_tabs = 2;
              tab_switch_strategy = "previous";
              tab_powerline_style = "slanted";

              active_tab_foreground = "#000";
              active_tab_background = "#eee";
              active_tab_font_style = "bold-italic";
              inactive_tab_foreground = "#444";
              inactive_tab_background = "#999";
              inactive_tab_font_style = "normal";

              background_opacity = 0.5;
              background_blur = 1;
            };
          };
          # zoxide = {
          #   enable = true;
          #   enableFishIntegration = true;
          # };
          vesktop.enable = cfg.enableGraphical;
          # zed-editor = {
          #   enable = false;
          #   # 	extensions = [
          #   # 		"nix"
          #   # 		"assembly syntax"
          #   # 		"github dark default"
          #   # 		"git firefly"
          #   # 		"toml"
          #   # 		"html"
          #   # 		"xml"
          #   # #		"activitywatch"
          #   # 	];
          #   # userSettings = {
          #   # 	theme = "Github Dark Default";
          #   # 	show_edit_predictions = false;
          #   # 	agent = {
          #   # 		default_profile = "minimal";
          #   # 		default_model = {
          #   # 			provider = "zed.dev";
          #   # 			model = "claude-sonnet-4";
          #   # 		};
          #   # 		version = "2";
          #   # 	};
          #   # 	features = {
          #   # 		edit_prediction_provider = "supermaven";
          #   # 	};
          #   # 	ui_font_size = 16;
          #   # 	buffer_font_size = 12.0;
          #   # };
          # };

          distrobox = {
            enable = true;
            containers = {
              ubuntu = {
                entry = true;
                image = "ubuntu:lts";
                # start_now=true;
                # init=true;
                # replace=false;
                # volume="~/.";
                additional_packages = [
                  "hello"
                  "git"
                  "micro"
                  "build-essential"
                  "bat"
                  "ripgrep"
                ];
              };
            };
          };
        };
      };
    };
  };
}
