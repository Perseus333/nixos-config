{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./boot.nix
    ./caddy-conf.nix
    ./disko.nix
    #./hardening-assignments.nix
    ./impermanence.nix
    ./hardware.nix
    ./wireguard.nix
    ../../modules/base
    ../../modules/networking
    ../../modules/services
  ];

  ivy = {
    # Server role assigns firewall zones & networking modules
    roles.server = {
      enable = true;
      # Toggle other options if necessary
    };
    zfs.enable = true;
  };

  # Host identification
  networking = {
    hostName = "venti";
    hostId = "e281e2d1";
    wireless.enable = true;
  };

  # Simple security logs
  services.journald = {
    extraConfig = ''
      SystemMaxUse=500M
    '';
  };

  system.stateVersion = "25.05";
}
