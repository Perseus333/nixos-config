{ config, lib, pkgs, ... }:

{
  nix.settings.experimental-features = [ "flakes" "nix-command" ];
  nix.optimise.automatic = true;
}
