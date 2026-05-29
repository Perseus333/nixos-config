{ config, lib, pkgs, ... }:

{
  boot.initrd.systemd.services.rollback = {
    description = "Rollback rpool/local/root to blank snapshot";
    wantedBy    = [ "initrd.target" ];
    after       = [ "zfs-import.target" ];
    before      = [ "sysroot.mount" ];
    path        = [ pkgs.zfs ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = "zfs rollback -r rpool/local/root@blank";
  };
}
