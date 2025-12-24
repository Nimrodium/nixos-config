{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  home-manager = inputs.home-manager;
  zen-browser = inputs.zen-browser.packages.${pkgs.system}.default;
  cfg = config.kyle-home;
in
{
  options.kyle-home = {
    enable = lib.mkEnableOption "enable kyle home";
  };
  config = lib.mkIf cfg.enable {
    home-manager = {
      backupFileExtension = "home-manager-backup1";

      users.kyle = {
        # gtk = {
        # 	enable = true;
        # 	theme.name = "Adwaita-dark";
        # 	cursorTheme.name = "Bibata-Modern-Ice";
        # 	iconTheme.name = "Adwaita";
        # 	gtk3.extraConfig = {
        # 		Settings = ''
        # 			gtk-application-prefer-dark-theme=1
        # 		'';
        # 	};
        # 	gtk4.extraConfig = {
        # 		Settings = ''
        # 			gtk-application-prefer-dark-theme=1
        # 		'';
        # 	};
        # };
        dconf = {
          enable = true;
          settings = {
            "org/gnome/desktop/interface" = {
              color-scheme = "prefer-dark";
            };
            "org/gnome/shell" = {
              disable-user-extensions = false;
              enabled-extensions = with pkgs.gnomeExtensions; [
                blur-my-shell.extensionUuid
                gsconnect.extensionUuid
                dash-to-dock.extensionUuid
              ];
            };
          };
        };
        # xdg = {
        # 		mimeApps = {
        # 		enable = true;
        # 		defaultApplications = {
        # 			"x-scheme-handler/http" = "zen-browser.desktop";
        # 			"x-scheme-handler/https" = "zen-browser.desktop";
        # 			"x-terminal-emulator" = "kitty.desktop";
        # 			"text/html" = "zen-browser.desktop";
        # 		};
        # 	};
        # };

        wayland.windowManager.hyprland = {
          enable = true;
          plugins = [
            # inputs.Hyprspace.packages.${pkgs.system}.Hyprspace
            # inputs.hyprgrass.packages.${pkgs.system}.default
            pkgs.hyprlandPlugins.hyprspace
            pkgs.hyprlandPlugins.hyprgrass
          ];
          # plugins = with pkgs.hyprlandPlugins; [
          # 	hyprgrass
          # 	hyprspace
          # ];
        };
        services = {
          # hyprpaper.enable = true;
          podman = {
            enable = true;
          };
        };
        # home.pointerCursor.hyprcursor = {
        # 	enable = true;
        # };
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
          packages = lib.mkMerge [
            (with pkgs; [
              ytmdesktop
              inconsolata
              source-code-pro
              krita
              zen-browser
              vscode
              gdu
              scrcpy

            ])
            (with pkgs.gnomeExtensions; [
              blur-my-shell
              gsconnect
              dash-to-dock
            ])
          ];
        };

        # gtk3 = {
        # 	extraConfig = {
        # 		gtk-theme-name = "Adwaita-dark";
        # 		gtk-icon-theme-name = "Papirus";
        # 	};
        # };
        # gtk4 = {
        # 	extraConfig = {
        # 		gtk-theme-name = "Adwaita-dark";
        # 		gtk-icon-theme-name = "Papirus";
        # 	};
        # };
        programs = {
          nix-index = {
            enable = true;
            enableFishIntegration = true;
          };
          # gtk.enable = true;
          home-manager.enable = true;
          chromium.enable = true;
          # for zed's generic linux lsp binaries to work
          # nix-ld.enable = true;
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

          hyprlock.enable = true;

          micro.enable = true;
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
              # name = "inconsolata";
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
              # font_size =11.0;
            };
          };
          # open-webui.enable = true;
          zoxide = {
            enable = true;
            enableFishIntegration = true;
          };
          fastfetch.enable = true;
          vesktop.enable = true;
          zed-editor = {
            enable = true;
            # 	extensions = [
            # 		"nix"
            # 		"assembly syntax"
            # 		"github dark default"
            # 		"git firefly"
            # 		"toml"
            # 		"html"
            # 		"xml"
            # #		"activitywatch"
            # 	];
            # userSettings = {
            # 	theme = "Github Dark Default";
            # 	show_edit_predictions = false;
            # 	agent = {
            # 		default_profile = "minimal";
            # 		default_model = {
            # 			provider = "zed.dev";
            # 			model = "claude-sonnet-4";
            # 		};
            # 		version = "2";
            # 	};
            # 	features = {
            # 		edit_prediction_provider = "supermaven";
            # 	};
            # 	ui_font_size = 16;
            # 	buffer_font_size = 12.0;
            # };
          };
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
              zed = "zeditor";
              # hx = "helix";
              edit = "ms-edit";
              ubuntu = "distrobox enter ubuntu-latest";
              # showgpu = "lspci -nnk | rg 28:00 -A 5";
              # windows = "virsh start win11-gpu-no-spice";
              # stopwindows = "virsh shutdown win11-gpu-no-spice";
              soft-reboot = "sudo systemctl soft-reboot";
            };
          };
          nh = {
            enable = true;
            clean.enable = true;
            clean.extraArgs = "--keep-since 4d --keep 3";
            flake = "/etc/nixos";
          };

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
