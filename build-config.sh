#!/usr/bin/env bash
git -C ./nixos-config pull
# time nix build ./nixos-config#nixosConfigurations.${1}.config.system.build.toplevel -j16
time nh os build ./nixos-config#nixosConfigurations.${1}.config.system.build.toplevel -j16
