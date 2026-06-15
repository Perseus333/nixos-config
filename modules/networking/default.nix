{ config, lib, ... }:

{
  imports = [
    ../../modules/networking/adblock.nix
    ../../modules/networking/caddy.nix
    ../../modules/networking/cert-manager.nix
    ../../modules/networking/port-map.nix
    ../../modules/networking/ssh.nix
    ../../modules/networking/unbound.nix
    ../../modules/networking/wireless.nix
    ../../modules/networking/wireguard.nix
  ];

  config = lib.mkMerge [

    # Loaded by all:
    # - SSH
    # - Wireguard
    # - Port-map

    (lib.mkIf config.ivy.roles.server.enable {
      services.caddy.enable   = lib.mkDefault true;
      services.unbound.enable = lib.mkDefault true;

      ivy.roles.server.adblock.enable      = lib.mkDefault true;
      ivy.roles.server.cert-manager.enable = lib.mkDefault true;
    })
  ];
}
