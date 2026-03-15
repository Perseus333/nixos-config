{ config, lib, pkgs, ... }:

{
  fileSystems."/mnt/backup" = {
    device = "/dev/disk/by-label/backup";
    fsType = "ext4";
    options = [ "defaults" "nofail" "x-systemd.device-timeout=10s" ];
  };

  environment.systemPackages = with pkgs; [ restic rclone backrest ];
  
  users.users.backrest = {
    isSystemUser = true;
    group = "backrest";
    home = "/var/lib/backrest";
    createHome = false; # systemd.tmpfiles already handles this
  };
  users.groups.backrest = {};

  # Give the backup disk to the backrest user
  systemd.tmpfiles.rules = [
    "d /mnt/backup 0750 backrest backrest -"
    "d /var/lib/backrest 0750 backrest backrest -"
  ];

  systemd.services.backrest = {
    description = "Backrest backup service";
    wantedBy = [ "multi-user.target" ];
    requires = [ "network-online.target" "mnt-backup.mount" ];
    after = [ "network-online.target" "mnt-backup.mount" ];
    script = "backrest";
    path = [ pkgs.backrest pkgs.restic pkgs.rclone ];
    environment = {
      BACKREST_PORT = "127.0.0.1:9898";
      BACKREST_DATA = "/var/lib/backrest";
    };
    serviceConfig = {
      Type = "simple";
      User = "backrest";
      Group = "backrest";

      AmbientCapabilities = [ "CAP_DAC_READ_SEARCH" ];
      CapabilityBoundingSet = [ "CAP_DAC_READ_SEARCH" ];

      # Cannot gain more privileges than this
      NoNewPrivileges = true;

      # Filesystem is read-only for backrest except explicit paths
      ProtectSystem = "strict";
      ReadWritePaths = [ "/var/lib/backrest" "/mnt/backup" ];

      # Must be false — we need to read /home and /root
      ProtectHome = false;

      # Remaining hardening
      PrivateTmp = true;
      PrivateDevices = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      RestrictSUIDSGID = true;
      LockPersonality = true;
    };
  };
}
