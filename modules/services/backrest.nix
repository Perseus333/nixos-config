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
    createHome = false;
    extraGroups = [ "media-mod" ];
  };
  users.groups.backrest = {};

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
      BACKREST_PORT = "127.0.0.1:${toString config.ports.backrest}";
      BACKREST_DATA = "/var/lib/backrest";
    };
    serviceConfig = {
      Type = "simple";
      User = "backrest";
      Group = "backrest";

      AmbientCapabilities  = [ "CAP_DAC_READ_SEARCH" ];
      CapabilityBoundingSet = [ "CAP_DAC_READ_SEARCH" ];
      ProtectHome          = false;
      ReadWritePaths       = [ "/var/lib/backrest" "/mnt/backup" ];
      MemoryDenyWriteExecute   = false; 
    };
  };
}
