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
    openDefaultPorts = true;
    settings.gui = {
      user = "perseus";
      passwordFile = config.sops.secrets."syncthing-pwd".path;
      insecureSkipHostcheck = true;
      options = {
	natEnabled = false;
	urAccepted = -1;
      };
    };
  };
}
