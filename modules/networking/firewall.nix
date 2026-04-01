{ config, lib, pkgs, ... }:

{
  networking.firewall = {
    enable = true;
    logRefusedConnections = true;
    trustedInterfaces = [ "wg0" ];
  };
}
