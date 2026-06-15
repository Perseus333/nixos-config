{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    #./hardening-assignments.nix
    ./hardware.nix
    ./wireguard.nix
    ../../modules/base
    ../../modules/networking
  ];

  # This configures most stuff
  ivy.roles.relay.enable = true;

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
