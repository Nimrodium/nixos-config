{
  lib,
  config,
  pkgs,
  ...
}:
let
  # module = "definedUsers";
  cfg = config.definedUsers;
in
{
  options.definedUsers = {
    kyle = lib.mkEnableOption "enable the kyle user";
    clara = lib.mkEnableOption "enable the clara user";
  };
  config.users.users = {
    clara = lib.mkIf cfg.clara {
      isNormalUser = true;
      description = "clara";
      shell = pkgs.fish;
      extraGroups = [
        "wheel"
        "input"
        "networkmanager"
      ];
    };
    kyle = lib.mkIf cfg.kyle {
      isNormalUser = true;
      hashedPassword = "$6$5bWc7XKnG8g3V1LN$oZVp2orw6uyAXZRLxawFYt2ObcyQOZHmC1e3jeDH8L3gSI54wtfzJJUezazk20Yji1d7MVjOMHAQix772Opj01";
      description = "kyle";
      shell = pkgs.fish;
      extraGroups = [
        "wheel"
        "input"
        "networkmanager"
        "libvirtd"
      ];
    };
  };
}
