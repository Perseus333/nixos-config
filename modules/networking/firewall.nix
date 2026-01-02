{ config, lib, pkgs, ... }:

{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 443 80 9068 4684 ];
    allowedUDPPorts = [ 1558 ];
    logRefusedConnections = true;
    trustedInterfaces = [ "wg0" ];
  };
}
