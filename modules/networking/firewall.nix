{ config, lib, pkgs, ... }:

{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 4433 4684 ];
    allowedUDPPorts = [ 1558 ];
    logRefusedConnections = true;
    trustedInterfaces = [ "wg0" ];
  };
}
