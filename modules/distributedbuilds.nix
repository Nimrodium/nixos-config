{ pkgs, ... }:
{
  nix.distributedBuilds = true;
  nix.settings.builders-use-substitutes = true;
  environment.variables.NIXSSH_OPTS="-p 8022";
  nix.buildMachines = [
    {
      hostName = "99.107.90.205";
      sshUser = "nixremote";
      sshKey = "/root/.ssh/id_ed25519";
      system = pkgs.stdenv.hostPlatform.system;
      supportedFeatures = [ "nixos-test" "big-parallel" "kvm" ];
    }
  ];
}
