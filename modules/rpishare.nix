{lib,config,pkgs,...}:
let cfg = config.rpishare; in {
  options.rpishare = {
    enable = lib.mkEnableOption "enable raspi share";
    mountpoint = lib.mkOption {
      type = lib.types.str;
      default = "/mnt/rpi";
      description = "mount point for rpi share";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      rclone
    ];
    environment.etc."rclone-mnt.conf".source = ../config/rclone/rclone-mnt.conf;
    fileSystems.${cfg.mountpoint} = {
      device = "raspi:/";
      fsType = "rclone";
      options = [
        "nodev"
        "nofail"
        "allow_other"
        "allow_non_empty"
        "uid=1000"
        "gid=1000"
        "args2env"
        "config=/etc/rclone-mnt.conf"
      ];
    };
  };
}
