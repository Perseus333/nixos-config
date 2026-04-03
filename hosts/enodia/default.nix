{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    #./hardening-assignments.nix
    ./caddy-conf.nix
    ./hardware.nix
    ./wireguard.nix
    ../../modules/base/home.nix
    ../../modules/base/nix.nix
    ../../modules/base/security.nix
    ../../modules/base/users.nix
    ../../modules/networking/acme.nix
    ../../modules/networking/caddy.nix
    ../../modules/networking/firewall.nix
    ../../modules/networking/ssh.nix
    ../../modules/networking/fail2ban.nix
    ../../modules/networking/wireguard.nix
  ];

  # Host identification
  networking = {
    hostName = "enodia";
    hostId = "238579e0";
  };

  # Enable relay
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  # Timezone
  time.timeZone = "Europe/London";

  # System packages
  environment.systemPackages = with pkgs; [
    vim 
    wget
    wpa_supplicant
    iproute2
    iputils
    git
    tree
    tmux
    age
    sops
    home-manager
    dig
    wireguard-tools
    btop
    tcpdump
  ];

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
  };

  system.stateVersion = "25.05";
}
