{ config, lib, pkgs, ... }:
{
  boot.initrd.systemd.services.rollback = {
    description = "Rollback btrfs root subvolume to blank";
    wantedBy = [ "initrd.target" ];
    after = [ "initrd-root-device.target" ];
    before = [ "sysroot.mount" ];
    
    path = with pkgs; [ btrfs-progs ];
    
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir -p /tmp/setup
      mount -t btrfs /dev/disk/by-partlabel/disk-main-root /tmp/setup
      if [ -e /tmp/setup/@root ]; then
        btrfs subvolume delete /tmp/setup/@root
      fi
      btrfs subvolume snapshot /tmp/setup/@root-blank /tmp/setup/@root
      umount /tmp/setup
    '';
  };
}
