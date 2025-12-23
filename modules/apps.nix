# for gui applications
{lib, config, inputs, pkgs, ...}:
let cfg = config.apps; in {
  imports = [];
  options.apps = {
    enable = lib.mkEnableOption "enable graphical apps";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      protonvpn-gui

    ];
  };
}
