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
    ../../modules/networking/acme.nix
    ../../modules/networking/acme-dns.nix
    ../../modules/networking/blocklist.nix
    ../../modules/networking/caddy.nix
    ../../modules/networking/ethernet.nix
    ../../modules/networking/fail2ban.nix
    ../../modules/networking/port-map.nix
    ../../modules/networking/ssh.nix
    ../../modules/networking/unbound.nix
    ../../modules/networking/wireless.nix
    ../../modules/networking/wireguard.nix
    ../../modules/services
  ];

  firewall-zones.role = "server";
  system.zfs.enable = true;

  # Host identification
  networking = {
    hostName = "venti";
    hostId = "e281e2d1";
  };

  # Timezone
  time.timeZone = "Europe/London";

  # Simple security logs
  services.journald = {
    extraConfig = ''
      SystemMaxUse=500M
    '';
  };

  system.stateVersion = "25.05";
}
