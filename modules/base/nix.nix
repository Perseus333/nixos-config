{ config, lib, pkgs, ... }:

{
  nix.settings.experimental-features = [ "flakes" "nix-command" ];
  nix.optimise.automatic = true;

  # Fixes namespace restrixtion on nix applied collateraly from systemd service hardening
  systemd.services.nix-daemon.serviceConfig = {
    RestrictNamespaces = lib.mkForce false;
  };

}
