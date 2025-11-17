{ config, lib, pkgs, ... }:

{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 4684 ];
    allowedUDPPorts = [ 1558 53 ];
    logRefusedConnections = true;
  };
}
