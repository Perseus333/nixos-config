{ config, lib, pkgs, secrets, ... }:
let
  wg-secrets = "${secrets}/services/wireguard.yaml";
in
{
  sops.secrets.wg-enodia-private-key = { sopsFile = "${wg-secrets}"; };
  sops.secrets.wg-pandora-enodia-psk = { sopsFile = "${wg-secrets}"; };
  sops.secrets.wg-fedora-enodia-psk  = { sopsFile = "${wg-secrets}"; };
  sops.secrets.wg-xiaomi-enodia-psk  = { sopsFile = "${wg-secrets}"; };
  sops.secrets.wg-s5e-enodia-psk     = { sopsFile = "${wg-secrets}"; };
  sops.secrets.wg-mm-enodia-psk      = { sopsFile = "${wg-secrets}"; };

  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.8.0.5/24" ];
    mtu = 1280;
    
    privateKeyFile = config.sops.secrets.wg-enodia-private-key.path;

    postSetup = ''
      # Configuration to relay the connection (AI made)
      ${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -i ens6 -p tcp --dport 25565 -j DNAT --to-destination 10.8.0.1:25565
      ${pkgs.iptables}/bin/iptables -A FORWARD -i ens6 -o wg0 -p tcp --dport 25565 -j ACCEPT
      ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -o ens6 -m state --state ESTABLISHED,RELATED -j ACCEPT
      ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o wg0 -p tcp -d 10.8.0.1 --dport 25565 -j MASQUERADE
      
      # WebDAV & SFTP
      ${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -i ens6 -p tcp -m multiport --dports 2022,10080 -j DNAT --to-destination 10.8.0.1
      ${pkgs.iptables}/bin/iptables -A FORWARD -i ens6 -o wg0 -p tcp -m multiport --dports 2022,10080 -j ACCEPT
    '';

    preShutdown = ''
      # Configuration to relay the connection (AI made)
      ${pkgs.iptables}/bin/iptables -t nat -D PREROUTING -i ens6 -p tcp --dport 25565 -j DNAT --to-destination 10.8.0.1:25565
      ${pkgs.iptables}/bin/iptables -D FORWARD -i ens6 -o wg0 -p tcp --dport 25565 -j ACCEPT
      ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -o ens6 -m state --state ESTABLISHED,RELATED -j ACCEPT
      ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o wg0 -p tcp -d 10.8.0.1 --dport 25565 -j MASQUERADE
      
      # WebDAV & SFTP
      ${pkgs.iptables}/bin/iptables -t nat -D PREROUTING -i ens6 -p tcp -m multiport --dports 2022,10080 -j DNAT --to-destination 10.8.0.1
      ${pkgs.iptables}/bin/iptables -D FORWARD -i ens6 -o wg0 -p tcp -m multiport --dports 2022,10080 -j ACCEPT
    '';

    peers = [
      {
        # pandora-server
        publicKey = "wCP4CrBEY/3DUj1z8oR+eduX4QpEgP9BvTna2aoOcHs=";
        presharedKeyFile = config.sops.secrets.wg-pandora-enodia-psk.path;
        allowedIPs = [ "10.8.0.1/32" ];
        persistentKeepalive = 25;
      }
      {
        # fedora-laptop
        publicKey = "DG7QHUUJVB2WHKYkWJ7XRBaC4D4hubtJ2PBiq/y5slw=";
        presharedKeyFile = config.sops.secrets.wg-fedora-enodia-psk.path;
        allowedIPs = [ "10.8.0.2/32" ];
      }
      {
        # lineageos-phone (xiaomi)
        publicKey = "LyQMscskUxGoJHAWA/Ebl6cghDOPxmeknbAHq71z8E8=";
        presharedKeyFile = config.sops.secrets.wg-xiaomi-enodia-psk.path;
        allowedIPs = [ "10.8.0.3/32" ];
      }
      {
        # lineageos-tablet (s5e)
        publicKey = "N4Nt8s9iMQEPR77IS0OdvyCFp3hbWpqh4rVlbYMga0U=";
        presharedKeyFile = config.sops.secrets.wg-s5e-enodia-psk.path;
        allowedIPs = [ "10.8.0.4/32" ];
      }
      {
        # phone-mm
        publicKey = "3a9hbEgNZ/XCMc6t+v8wjBv7iL7394V397EeGoz0phY=";
        presharedKeyFile = config.sops.secrets.wg-mm-enodia-psk.path;
        allowedIPs = [ "10.8.0.6/32" ];
      }
    ];
  };
}
