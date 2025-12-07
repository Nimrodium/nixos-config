{config,pkgs,...}:{
  nix.buildMachines = [
    {
      hostName = "99.107.90.205:8022";
      sshUser = "nixremote";
      system = "x86_64-linux";
      protocol = "ssh-ng";
      maxJobs = 1;
      speedFactor = 2;
      supportedFeatures = [ "big-parallel" ];
      mandatoryFeatures = [];
    }
  ];
  nix.distributedBuilds = true;
  nix.builders-use-substitutes = true;
}
