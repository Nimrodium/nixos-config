{ config, pkgs,inputs, ... }:
let 
	home-manager = inputs.home-manager;
in
{
	home-manager.users.kyle = {
		home.stateVersion = "25.05";

		home.packages = with pkgs; [
			hello
		];
	};
}
