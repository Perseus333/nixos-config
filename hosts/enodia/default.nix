{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    #./hardening-assignments.nix
    ./hardware.nix
    ./wireguard.nix
    ../../modules/base/nix.nix
    ../../modules/base/security.nix
    ../../modules/base/users.nix
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
    device = "nodev";
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  system.stateVersion = "25.05";
}
