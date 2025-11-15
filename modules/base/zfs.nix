{ config, lib, pkgs, ... }:

{
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
}
