{ config, lib, secrets, ... }:
let
  wg-secrets = "${secrets}/hosts/venti.yaml";

  secret-names = [
    "wg-venti-endpoint-private-key"
    "wg-venti-backbone-private-key"
    "wg-fedora-venti-psk"
    "wg-gos-venti-psk"
  ];
in
{
  sops.secrets = (lib.genAttrs secret-names (name: { sopsFile = wg-secrets; })) // {
    wg-venti-xiao-psk = { sopsFile = "${secrets}/shared/xiao-venti.yaml"; };
  };

  networking.wireguard.interfaces = {

    ${config.ivy.firewall-zones.relay.backboneInterface} = {
      ips = [ "10.8.1.1/24" ];
      privateKeyFile = config.sops.secrets."wg-venti-backbone-private-key".path;
      mtu = 1280;
      peers = [
        {
          name = "xiao-vps";
          publicKey = "e3Jf/ZOJFBLw23k1KSAq6UpjFPRRKWrrJRXc6/Irx2Y=";
          presharedKeyFile = config.sops.secrets."wg-venti-xiao-psk".path;
          allowedIPs = [ "10.8.1.2/32" ];
          # TODO: Turn relay IP into a secret
          endpoint = "87.106.83.12:${toString config.ivy.firewall-zones.relay.backboneTunnelPort}";
          persistentKeepalive = 25;
        }
      ];
    };

    ${config.ivy.firewall-zones.server.endpointInterface} = {
      ips = [ "10.8.0.1/24" ];
      privateKeyFile = config.sops.secrets."wg-venti-endpoint-private-key".path;
      mtu = 1280;
      peers = [
        {
          # fedora-laptop (kazuha)
          publicKey = "DG7QHUUJVB2WHKYkWJ7XRBaC4D4hubtJ2PBiq/y5slw=";
          presharedKeyFile = config.sops.secrets.wg-fedora-venti-psk.path;
          allowedIPs = [ "10.8.0.2/32" ];
        }
        {
          # grapheneos-phone
          publicKey = "zkVsHUkAvlzHQQYCOAbFzTu1KJocGbZZN5Debn9cSU0=";
          presharedKeyFile = config.sops.secrets.wg-gos-venti-psk.path;
          allowedIPs = [ "10.8.0.7/32" ];
        }
      ];
    };
  };
}
