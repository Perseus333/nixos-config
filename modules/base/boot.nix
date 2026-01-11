{ config, lib, pkgs, ... }:

{
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/disk/by-id";
  boot.kernelParams = [ "zfs.zfs_arc_max=4294967296" ]; # Max 4 GB for ARC
  swapDevices = [ { device = "/dev/zvol/rhea/swap"; } ];
}
