{ config, lib, pkgs, ... }:
{
  sops.secrets."syncthing-pwd" = {
    owner = "syncthing";
  };

  users.users.syncthing.extraGroups = [
    "private-files"
    "media-private"
    "media-public"
  ];

  services.syncthing = {
    enable = true;

    overrideDevices = true;
    overrideFolders = true;

    settings = {
      guiAddress = "0.0.0.0:${ toString config.ports.syncthing}";
      gui = {
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
        "MBL" = { id = "D5MIWDK-BZGZHBR-ZXZM3JP-P2D56SB-DYVLXE5-K4NCZ7H-Y3Q2RIQ-GBWLYQV"; };
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
        # MBL Backup: Music
        "mbl-music" = {
          path = "/srv/media/harmonics";
          devices = [ "MBL" ];
          type = "receiveonly";
          ignoreDelete = true;
        };
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d  /srv/files/hot-storage      2770  syncthing  private-files  -  -"
    "d  /srv/media/immich-ingest    2770  syncthing  private-files  -  -"
    "d  /srv/media/harmonics        2770  syncthing  public-files   -  -"
  ];

  systemd.services.syncthing.serviceConfig = {
    ReadWritePaths = [
      "/var/lib/syncthing"
      "/srv/files"
      "/srv/media/immich-ingest"
      "/srv/media/harmonics"
    ];
    SystemCallFilter = [ "@system-service" "setpriority" "~@privileged" ];
  };
}
