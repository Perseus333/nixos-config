{ config, lib, pkgs, ... }:

{
  # This should not have to be an option in 26.05
  nix.settings.experimental-features = [ "flakes" "nix-command" ];
  # Removes redundant files in the nix store
  nix.optimise.automatic = true;

  # For more flexibility use this script
  # https://nixos.wiki/wiki/NixOS_Generations_Trimmer
  nix.gc = {
    automatic = true;
    # Technically it works because nix.gc is a wrapper for nix-collect-garbage, 
    # which for this option is equivalent to nix-env --delete-generations,
    # which supports specifying an amount. Idk if it works, but it "compiles".
    options = "--delete-generations +10";
  };

  # Allow unfree packages because several of the ones I run suddenly are
  nixpkgs.config.allowUnfree = true;
}
