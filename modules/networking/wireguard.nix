{ config, pkgs, lib, ... }:

{
  networking.wireguard.interfaces = {
    wg0 = {
      # TODO: define port as a variable
      listenPort = 1558;
    };
  };
}
