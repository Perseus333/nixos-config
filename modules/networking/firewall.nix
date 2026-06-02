{ config, lib, pkgs, ... }:

{
  networking.firewall = {
    enable = true;
    logRefusedConnections = true;
    trustedInterfaces = [ "wg0" ];

    allowedTCPPorts = []; 

    # Open ports for SSH in local networks and wireguard
    extraCommands = ''
      ${pkgs.iptables}/bin/iptables  -A INPUT -p tcp --dport 4684 -s 192.168.0.0/16     -j ACCEPT
      ${pkgs.iptables}/bin/iptables  -A INPUT -p tcp --dport 4684 -s 10.0.0.0/8         -j ACCEPT
      ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp --dport 4684 -s fd7b:323:3ba9::/48 -j ACCEPT
    '';
  };
}
