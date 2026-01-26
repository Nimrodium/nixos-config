# nix module to build a shell script
# which can call systemctl restart iwd without needing sudo password.
# has optional hyprctl notify instead of console logging for use of keybind
{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.restartIwd;
  # using #{pkgs.sudo}/bin/sudo raises a security error.
  command = "${pkgs.systemd}/bin/systemctl restart iwd.service";
in
{
  options.restartIwd = {
    enable = lib.mkEnableOption "enable sudoless IWD restart command";
  };
  config = lib.mkIf cfg.enable {
    security.sudo.extraRules = [
      # ''
      #   kyle ALL=(ALL:ALL) NOPASSWD: ${pkgs.systemd}/bin/systemctl restart iwd
      # ''
      {
        users = [ "kyle" ];
        commands = [
          {
            inherit command;
            options = [
              "SETENV"
              "NOPASSWD"
            ];
          }
        ];
      }
    ];
    environment.systemPackages = with pkgs; [
      (writeShellScriptBin "restart-iwd" ''
        isHypr=$1
        displayOutcome(){
            msg=$1
            success=$2

            if [ "$isHypr" = "hypr" ]; then
                if [ $success -eq 0 ]; then
                        successColor="rgb(00ff00)"
                    else
                        successColor="rgb(ff0000)"
                fi
                    ${pkgs.hyprland}/bin/hyprctl notify -1 1000 $successColor $msg
                else
                    if [ $success -eq 0 ]; then
                            successText="Success:"
                        else
                            successText="Failure:"
                    fi
                    echo $successText $msg
            fi
        }
        displayOutcome "restarting Iwd" 1
        sudo ${command}
        if [ $? -eq 0 ]; then
                displayOutcome "restarted IWD" $?
            else
                displayOutcome "could not restart iwd" $?
                ${pkgs.systemd}/bin/systemctl status iwd.service
        fi
      '')
    ];
  };
}
