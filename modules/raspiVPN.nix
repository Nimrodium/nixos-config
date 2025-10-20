{config,lib,pkgs,inputs}:
let cfg = config.raspiVPN; in {
  imports = [];
  options.raspiVPN = {
    enable = lib.mkEnableOption "enable RaspiVPN module";
  };
  config = lib.mkIf cfg.enable {

  };
}
