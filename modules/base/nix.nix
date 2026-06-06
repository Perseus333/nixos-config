{ config, lib, pkgs, ... }:

{
  nix.settings.experimental-features = [ "flakes" "nix-command" ];
  nix.optimise.automatic = true;

  # If you have too many generations use this script
  # https://nixos.wiki/wiki/NixOS_Generations_Trimmer
  # TODO: Configure nix.gc to save last 5 generations
}
