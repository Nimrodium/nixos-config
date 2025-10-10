{ lib, config, ... }:
let cfg = config.raspi-share in {
  imports = [
    # Paths to other modules.
    # Compose this module out of smaller ones.
  ];

  options = {
  	raspi-share.enable = lib.mkEnableOption "Enable Module";
  	raspi-share.mountpoint = ;
  	raspi-share.source = ;
    # Option declarations.
    # Declare what settings a user of this module can set.
    # Usually this includes a global "enable" option which defaults to false.
  };

  config = lib.mkIf cfg.enable {
  	fileSystems.${cfg.mountpoint} = {
  		device = ${cfg.source}
  		fsType = "sshfs";
  		
  	};
    # Option definitions.
    # Define what other settings, services and resources should be active.
    # Usually these depend on whether a user of this module chose to "enable" it
    # using the "option" above. 
    # Options for modules imported in "imports" can be set here.
  };
}
