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
          "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIO0nWPCSX+E6Ze1tyHUZABf4gkfTjcxs5fXuqy6EfoYkAAAABHNzaDo= perseus@mycenae" # Yubikey1
          "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIPdXXZV1q964neYidTdL/fdyPuIhYzn353qe/G2BP4GvAAAABHNzaDo= perseus@mycenae" # Yubikey2
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
