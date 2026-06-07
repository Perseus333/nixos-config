{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    #./hardening-assignments.nix
    ./hardware.nix
    ./wireguard.nix
    ../../modules/base/home.nix
    ../../modules/base/nix.nix
    ../../modules/base/packages.nix
    ../../modules/base/security.nix
    ../../modules/base/users.nix
    ../../modules/networking/firewall.nix
    ../../modules/networking/ssh.nix
    ../../modules/networking/fail2ban.nix
    ../../modules/networking/wireguard.nix
  ];

  #sops.secrets.xiao-nix-signing-key = {
  #  owner = "root";
  #  group = "root";
  #  mode = "0400";
  #};

  # Host identification
  networking = {
    hostName = "xiao";
    hostId = "238579e0";
  };

  # Enable relay
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  # Timezone
  time.timeZone = "Europe/London";

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.initrd.systemd.enable = true;

  nix.settings = {
    # Only accept signing keys to rebuild nixos
    # Temporarily disabled due to "unplanned rotation"
    # trusted-public-keys = [ 
    #   "venti-cache:SkQAvcsDt0Ht2Fa9eVWcHycLh94L/eeoSrd4aFnctRc="
    #   "xiao-local:oHEK4qmcidPp+ot3V9lP8udtLBeKpaqy91wFs90OVS4="
    # ];

    # secret-key-files = [ config.sops.secrets.xiao-nix-signing-key.path ];
    # Set as false on the first run!
    # require-sigs = false;
  };

  system.stateVersion = "25.05";
}
