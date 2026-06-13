{ config, lib, secrets, ... }:
let
  wg-secrets = "${secrets}/services/wireguard.yaml";

  secret-names = [
    "wg-xiao-private-key"
    "wg-venti-xiao-psk"
    "wg-fedora-xiao-psk"
    "wg-xiaomi-xiao-psk"
    "wg-s5e-xiao-psk"
    "wg-mm-xiao-psk"
    "wg-gos-xiao-psk"
  ];
in
{
  sops.secrets = lib.genAttrs secret-names (name: { sopsFile = wg-secrets; });

  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.8.0.5/24" ];
    mtu = 1280;
    privateKeyFile = config.sops.secrets.wg-xiao-private-key.path;

    peers = [
      {
        # venti-server
        publicKey = "wCP4CrBEY/3DUj1z8oR+eduX4QpEgP9BvTna2aoOcHs=";
        presharedKeyFile = config.sops.secrets.wg-venti-xiao-psk.path;
        allowedIPs = [ "10.8.0.1/32" ];
        persistentKeepalive = 25;
      }
      {
        # fedora-laptop (kazuha)
        publicKey = "DG7QHUUJVB2WHKYkWJ7XRBaC4D4hubtJ2PBiq/y5slw=";
        presharedKeyFile = config.sops.secrets.wg-fedora-xiao-psk.path;
        allowedIPs = [ "10.8.0.2/32" ];
      }
      {
        # lineageos-phone (xiaomi)
        publicKey = "LyQMscskUxGoJHAWA/Ebl6cghDOPxmeknbAHq71z8E8=";
        presharedKeyFile = config.sops.secrets.wg-xiaomi-xiao-psk.path;
        allowedIPs = [ "10.8.0.3/32" ];
      }
      {
        # lineageos-tablet (s5e)
        publicKey = "N4Nt8s9iMQEPR77IS0OdvyCFp3hbWpqh4rVlbYMga0U=";
        presharedKeyFile = config.sops.secrets.wg-s5e-xiao-psk.path;
        allowedIPs = [ "10.8.0.4/32" ];
      }
      {
        # phone-mm
        publicKey = "3a9hbEgNZ/XCMc6t+v8wjBv7iL7394V397EeGoz0phY=";
        presharedKeyFile = config.sops.secrets.wg-mm-xiao-psk.path;
        allowedIPs = [ "10.8.0.6/32" ];
      }
      {
        # grapheneos-phone
        publicKey = "zkVsHUkAvlzHQQYCOAbFzTu1KJocGbZZN5Debn9cSU0="
        presharedKeyFile = config.sops.secrets.wg-gos-xiao-psk.path;
        allowedIPs = [ "10.8.0.7/32" ];
      }
    ];
  };
}
