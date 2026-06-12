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
      # Main resource: https://wiki.nixos.org/wiki/Remote_disk_unlocking
      network.ssh = {
        enable = true;
        port = config.ports.initrd-ssh;
        authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPL8XZ7KIhJ7SacYc0efJ+FQyCklHRBFLFhKDR7BPpU2 perseus@kazuha"
        ];
        hostKeys = [
          "/persist/etc/initrd/ssh/initrd_ed25519_key"
        ];
      };
      availableKernelModules = [
        "r8169" # Ethernet driver
      ];

      systemd.network = {
        enable = true;
        networks."eno1" = {
          matchConfig.Name = "eno1";
          networkConfig.DHCP = "ipv4";
        };
      };

      # Adapted from: https://elis.nu/blog/2026/04/nixos-zfs-remote-unlock-over-ssh/
      systemd.services.luks-ssh-unlock-setup = {
        description = "Prepare root .profile for LUKS passphrase via SSH";
        wantedBy    = [ "initrd.target" ];
        before      = [ "cryptsetup.target" ];
        unitConfig.DefaultDependencies = false;
        serviceConfig.Type = "oneshot";
        script = ''
          mkdir -p /var/empty
          printf '%s\n' "systemd-tty-ask-password-agent --watch" > /var/empty/.profile
        '';
      };
    };
  };
}
