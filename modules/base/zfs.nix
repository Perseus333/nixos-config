{ config, lib, ... }:

let
  cfg = config.ivy.zfs;
in
{
  options.ivy.zfs = {
    enable = lib.mkEnableOption "Enable ZFS configuration";
  };

  config = lib.mkIf cfg.enable {
    services.zfs = {
      autoSnapshot = {
        # Enables keeping 4 15min snapshots, 24 of 1h intervals, 7 of 1d, etc.
        enable = true;
        # --utc to prevent name conflicts
        flags = "-k -p --utc";
      };
      # Checks data integrity
      autoScrub = {
        enable = true;
        interval = "monthly";
      };
      # Runs "zpool trim" weekly
      trim = {
        enable = true;
      };
    };
    boot.supportedFilesystems = [ "zfs" ];
    boot.zfs.devNodes = "/dev/disk/by-id";
    boot.kernelParams = [ "zfs.zfs_arc_max=4294967296" ]; # Max 4 GB for ARC
  };
}
