# {config,lib,...}:
# let cfg = config.modules; in {
#   options.modules = {
#     graphical.enable = lib.mkEnableOption "enables hyprland desktop";
#     packages.enable = lib.mkEnableOption "enables shared packages";
#     rpishare.enable = lib.mkEnableOption "enable raspberry pi share";
#     home.kyle.enable = lib.mkEnableOption "enable home config for kyle";
#     apps.enable = lib.mkEnableOption "enables graphical apps";
#   };
# }
