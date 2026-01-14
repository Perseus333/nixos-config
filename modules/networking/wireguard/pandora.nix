{ config, pkgs, lib, ... }:

{
  sops.secrets.wireguard-pandora-private-key = {};
  sops.secrets.wireguard-pandora-preshared-key = {};

  networking.wireguard.interfaces = {
    vps-relay = {
      ips = [ "10.8.0.1/24" ];
      # TODO: define port as a variable
      listenPort = 1558;
      privateKeyFile = config.sops.secrets.wireguard-pandora-private-key.path;
      peers = [
        {
          name = "enodia-vps";
          publicKey = "6Sf+v5/ZpUFXK4BKaz5GrxafGe3V2VXkSPpAKs1seC8=";
          presharedKeyFile = config.sops.secrets.wireguard-pandora-preshared-key.path;
          allowedIPs = [ "10.8.0.0/24" ];
          endpoint = "87.106.83.12:1558";
          persistentKeepalive = 25;
        }
      ];
    };
    # TODO: Separate interface for direct connection with clients over LAN
  };
}
