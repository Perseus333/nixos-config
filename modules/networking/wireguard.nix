{ config, pkgs, lib, ... }:

{
  sops.secrets.wireguard-private-key = {};
  sops.secrets.wireguard-preshared-key = {};


  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.8.0.1/24" ];
      # TODO: define port as a variable
      listenPort = 1558;
      privateKeyFile = config.sops.secrets.wireguard-private-key.path;
      peers = [
        {
          name = "fedora-laptop";
          publicKey = "DG7QHUUJVB2WHKYkWJ7XRBaC4D4hubtJ2PBiq/y5slw=";
          presharedKeyFile = config.sops.secrets.wireguard-preshared-key.path;
          allowedIPs = [ "10.8.0.2/32" ];
        }
      ];
    };
  };
}
