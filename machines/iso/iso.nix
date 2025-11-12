{pkgs,lib,inputs,...}:
{
  imports = [
    ../../modules/nix.nix
    ../../modules/packages.nix
  ];
  packages.enable =true;
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.systemd.enable=true;
  };
  networking.wireless.iwd.settings = {
    IPv6 = {Enabled = true;};
    Settings = {AutoConnet = true;};
  };
  networking.hostName = "iso";
  systemd = {
    services.sshd.wantedBy = pkgs.lib.mkForce ["multi-user.target"];
    targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibermate.enable = false;
      hybrid-sleep.enable = false;
    };
  };
  home-manager.users.nixos = import ../../modules/kyle-home.nix;
  users.extraUsers.root.password = "nixos";
  }
