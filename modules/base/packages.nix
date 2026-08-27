{ config, lib, pkgs, ... }:

{
  # Common essential packages across machines
  environment.systemPackages = with pkgs; [
    # Essentials
    vim
    git
    tmux
    tree
    wget
    btop
    ncdu

    # Networking
    wpa_supplicant
    networkmanager
    dhcpcd
    iproute2
    iputils
    dig
    tcpdump
    wireguard-tools

    # Nix-specific
    age
    sops
    home-manager
    ssh-to-age

    # QOL
    unzip
    zip
    jq
  ];


}
