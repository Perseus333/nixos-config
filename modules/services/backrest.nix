{ config, lib, pkgs, ... }:

{
  fileSystems."/mnt/backup" = {
    device = "/dev/disk/by-label/backup";
    fsType = "ext4";
    options = [ "defaults" "nofail" "x-systemd.device-timeout=10s" ];
  };

  environment.systemPackages = with pkgs; [ restic rclone backrest ];

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
      User = "root";
      Group = "root";
      StateDirectory = "backrest";
    };
  };
}
