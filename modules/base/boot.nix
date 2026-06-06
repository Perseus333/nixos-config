{ config, lib, pkgs, ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      systemd.enable = true;
      network.enable = true;
      # To always have SSH access even when the system is borked
      network.ssh = {
        enable = true;
        port = 2222;
        authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPL8XZ7KIhJ7SacYc0efJ+FQyCklHRBFLFhKDR7BPpU2 perseus@kazuha" # default key
        ];
        hostKeys = [
          "/persist/etc/initrd/ssh/initrd_ed25519_key"
        ];
      };
      availableKernelModules = [
        "r8169" # Ethernet driver
      ];
    };
  };
}
