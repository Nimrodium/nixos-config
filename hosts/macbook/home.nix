{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.clara-home;
in
{
  options.clara-home = lib.mkEnableOption "enable clara home";
  config = lib.mkIf cfg.clara-home {
    home-manager = {
      backupFileExtension = "homemanager-backup";
      users.clara = {

      };
    };
  };
}
