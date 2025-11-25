{ config, lib, pkgs, ... }:

{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 4684 ];
    allowedUDPPorts = [ 443 1558 53 ];
    logRefusedConnections = true;
  };
}
