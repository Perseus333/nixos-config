{ config, lib, pkgs, ... }:

{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 53 80 433 4684 ];
    allowedUDPPorts = [ 53 1558 ];
    logRefusedConnections = true;
    trustedInterfaces = [ "wg0" ];
  };
}
