{ config, pkgs, lib, ... }:

{
  sops.secrets.wireguard-private-key = {};
  sops.secrets.wireguard-enodia-preshared-key = {};

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.8.0.1/24" ];
      # TODO: define port as a variable
      listenPort = 1558;
      privateKeyFile = config.sops.secrets.wireguard-private-key.path;
      peers = [
        {
          name = "enodia-vps";
          publicKey = "6Sf+v5/ZpUFXK4BKaz5GrxafGe3V2VXkSPpAKs1seC8=";
          presharedKeyFile = config.sops.secrets.wireguard-enodia-preshared-key.path;
          allowedIPs = [ "10.8.0.0/24" ];
          endpoint = "87.106.83.12:1558";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
