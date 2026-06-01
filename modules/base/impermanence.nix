{ config, lib, pkgs, ... }:

{
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
