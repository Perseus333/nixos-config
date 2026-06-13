{ config, lib, pkgs, ... }:

{
  fileSystems."/persist".neededForBoot = true;
  fileSystems."/home".neededForBoot = true;
  fileSystems."/srv".neededForBoot = true;

  boot.initrd.systemd.services.rollback = {
    description = "Rollback rpool/local/root to blank snapshot";
    wantedBy    = [ "initrd.target" ];
    after       = [ "zfs-import.target" ];
    before      = [ "sysroot.mount" ];
    path        = [ pkgs.zfs ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = "zfs rollback -r rpool/local/root@blank && echo 'Rollback complete'";
  };

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib"
      "/var/log"
      "/etc/ssh"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/machine-id"
    ];
  };
}
