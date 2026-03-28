{ config, lib, pkgs, ... }:

{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 4433 4684 ];
    allowedUDPPorts = [ 1558 ];
    logRefusedConnections = true;
    trustedInterfaces = [ "wg0" ];
    extraCommands = ''
      iptables -A INPUT -s 192.168.0.0/16 -p tcp --dport 8096 -j ACCEPT
    '';
  };
}
