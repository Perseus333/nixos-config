{ config, lib, secrets, ... }:

{
  sops.secrets.wg-venti-private-key = { sopsFile = "${secrets}/hosts/venti.yaml"; };
  sops.secrets.wg-venti-xiao-psk  = { sopsFile = "${secrets}/shared/xiao-venti.yaml"; };

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.8.0.1/24" ];
      privateKeyFile = config.sops.secrets."wg-venti-private-key".path;
      mtu = 1280;
      peers = [
        {
          name = "xiao-vps";
          publicKey = "6Sf+v5/ZpUFXK4BKaz5GrxafGe3V2VXkSPpAKs1seC8=";
          presharedKeyFile = config.sops.secrets."wg-venti-xiao-psk".path;
          allowedIPs = [ "10.8.0.0/24" ];
          endpoint = "87.106.83.12:1558";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
