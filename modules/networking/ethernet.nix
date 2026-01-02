{ config, lib, pkgs, ... }:

{
  networking.interfaces.enp1s0.useDHCP = true;
  networking.interfaces.eno1.useDHCP = true;
}

