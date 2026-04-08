{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    #./hardening-assignments.nix
    ./caddy-conf.nix
    ./disko.nix
    ./hardware.nix
    ./impermanence.nix
    ./wireguard.nix
    ../../modules/base/home.nix
    ../../modules/base/impermanence.nix
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

  sops.secrets.enodia-nix-signing-key = {
    owner = "root";
    group = "root";
    mode = "0400";
  };

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
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  boot.initrd.systemd.enable = true;

  nix.settings = {
    # Only accept signing keys to rebuild nixos
    trusted-public-keys = [ 
      "pandora-cache:SkQAvcsDt0Ht2Fa9eVWcHycLh94L/eeoSrd4aFnctRc="
      "enodia-local:oHEK4qmcidPp+ot3V9lP8udtLBeKpaqy91wFs90OVS4="
    ];

    secret-key-files = [ config.sops.secrets.enodia-nix-signing-key.path ];
    # Set as false on the first run!
    require-sigs = false;
  };

  system.stateVersion = "25.05";
}
