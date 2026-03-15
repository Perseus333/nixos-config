{ config, lib, pkgs, ... }:

{
  services.jellyfin = {
    enable = true;
  };
  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];

  systemd.services.jellyfin.serviceConfig = {
    PrivateDevices      = false;
    DeviceAllow         = [ "/dev/dri rw" ];
    SupplementaryGroups = [ "video" "render" ];

    ReadWritePaths = [
      "/var/lib/jellyfin"
      "/var/cache/jellyfin"
      "/srv/media"
    ];

    MemoryDenyWriteExecute = false;
  };
}
