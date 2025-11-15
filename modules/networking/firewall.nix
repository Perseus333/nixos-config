{ config, lib, pkgs, ... }:

{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 4684 ];
    logRefusedConnections = true;
  };
}
