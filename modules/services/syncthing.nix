{ config, lib, pkgs, ... }:
{
  sops.secrets."syncthing-pwd" = {
    owner = "syncthing";
  };
  users.users.syncthing = {
    extraGroups = [ "sftpgo" ];
  };
  services.syncthing = {
    enable = true;
    settings.gui = {
      user = "perseus";
      passwordFile = config.sops.secrets."syncthing-pwd".path;
      options = {
	natEnabled = false;
	urAccepted = -1;
      };
    };
  };
  systemd.services.syncthing.serviceConfig = {
    ReadWritePaths = [
      "/var/lib/syncthing"
      "/srv/files/private"
    ];
    SystemCallFilter = [ "@system-service" "setpriority" "~@privileged" ];
  };
}
