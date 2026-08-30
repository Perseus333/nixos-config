{ config, lib, secrets, ... }:
let
  wg-secrets = "${secrets}/hosts/xiao.yaml";

  secret-names = [
    "wg-xiao-backbone-private-key"
    "wg-xiao-admin-private-key"
    "wg-kazuha-admin-psk"
  ];
in
{
  sops.secrets = (lib.genAttrs secret-names (name: { sopsFile = wg-secrets; })) // {
    wg-venti-xiao-psk = { sopsFile = "${secrets}/shared/xiao-venti.yaml"; };
  };

  networking.wireguard.interfaces = {
    ${config.ivy.firewall-zones.relay.backboneInterface} = {
      ips = [ "10.8.1.2/24" ];
      mtu = 1380;
      privateKeyFile = config.sops.secrets.wg-xiao-backbone-private-key.path;
      listenPort = config.ivy.firewall-zones.relay.backboneTunnelPort;

      peers = [
        {
          # venti-server
          publicKey = "ogecRewIDChvixWVBF+biVwgXCO92pWKZHv8SJxJahc=";
          presharedKeyFile = config.sops.secrets.wg-venti-xiao-psk.path;
          allowedIPs = [ "10.8.1.1/32" ];
          persistentKeepalive = 25;
        }
      ];
    };

    ${config.ivy.firewall-zones.relay.adminInterface} = {
      ips = [ "10.8.2.1/24" ];
      mtu = 1280;
      privateKeyFile = config.sops.secrets.wg-xiao-admin-private-key.path;
      listenPort = config.ivy.firewall-zones.relay.adminPort;

      peers = [
        {
          # kazuha
          publicKey = "naq+dIzj3G7nH9eG8C+VCQxGWD8fezYuvaA+EYNMcEU=";
          presharedKeyFile = config.sops.secrets.wg-kazuha-admin-psk.path;
          allowedIPs = [ "10.8.2.2/32" ];
        }
      ];
    };
  };
}
