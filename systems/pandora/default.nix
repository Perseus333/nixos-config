{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/base/nix.nix
    ../../modules/base/boot.nix
    ../../modules/base/security.nix
    ../../modules/base/users.nix
    ../../modules/base/zfs.nix
    ../../modules/networking/acme.nix
    ../../modules/networking/caddy.nix
    ../../modules/networking/firewall.nix
    ../../modules/networking/ssh.nix
    ../../modules/networking/wireless.nix
    ../../modules/networking/fail2ban.nix
    ../../modules/networking/wireguard.nix
    ../../modules/networking/cloudflare-dyndns.nix
    ../../modules/networking/unbound.nix
    ../../modules/services/forgejo.nix
    ../../modules/services/jellyfin.nix
    ../../modules/services/samba.nix
  ];

  # Host identification
  networking = {
    hostName = "pandora";
    hostId = "e281e2d1";
  };

  # Timezone
  time.timeZone = "Europe/London";

  # System packages
  environment.systemPackages = with pkgs; [
    vim 
    wget
    wpa_supplicant
    networkmanager
    dhcpcd
    iproute2
    iputils
    git
    tree
    age
    sops
    home-manager
    dig
    wireguard-tools
    btop
  ];

  # Simple security logs
  services.journald = {
    extraConfig = ''
      SystemMaxUse=500M
    '';
  };

  system.stateVersion = "25.05";
}
