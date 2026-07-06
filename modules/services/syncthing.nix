{ config, lib, pkgs, ... }:
{
  sops.secrets."syncthing-pwd" = {
    owner = "syncthing";
  };

  users.users.syncthing.extraGroups = [
    "private-files"
    "media-private"
  ];

  services.syncthing = {
    enable = true;

    overrideDevices = true;
    overrideFolders = true;

    settings.guiAddress = "0.0.0.0:${ toString config.ports.syncthing}";
    settings.gui = {
      user = "perseus";
      passwordFile = config.sops.secrets."syncthing-pwd".path;
      options = {
	natEnabled = false;
	urAccepted = -1;
      };
      insecureSkipHostcheck = true;
    };

    devices = {
      "LTP" = { id = "OF7MA2O-6MCO5BX-K5IBMX2-KSTRE24-YZQKFWE-SVAURYS-GMZBEVT-2CFVMAX"; };
    };

    folders = {
      # LTP Backup: Essential files
      "hot-storage" = {
        path = "/srv/files/hot-storage"; 
        devices = [ "LTP" ];
        type = "receiveonly"; 
      };
      # LTP Backup: Screenshots
      "ltp-screenshots" = {
        path = "/srv/media/immich-ingest/ltp-screenshots";
        devices = [ "LTP" ];
        type = "receiveonly";
      };
      # LTP Backup: Wallpapers
      "ltp-wallpapers" = {
        path = "/srv/media/immich-ingest/ltp-wallpapers";
        devices = [ "LTP" ];
        type = "receiveonly";
      };
    };
  };

  systemd.services.syncthing.serviceConfig = {
    ReadWritePaths = [
      "/var/lib/syncthing"
      "/srv/files"
      "/srv/media/immich-ingest"
    ];
    SystemCallFilter = [ "@system-service" "setpriority" "~@privileged" ];
  };
}
