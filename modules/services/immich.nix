{ config, lib, pkgs, ... }:

let
  gpuOverride = {
    PrivateDevices      = lib.mkForce false;
    DeviceAllow         = [ "/dev/dri rw" ];
    SupplementaryGroups = [ "video" "render" ];
  };
in
{
  services.immich = {
    enable = true;
    host = "127.0.0.1";
    port = 2283;
    mediaLocation = "/srv/media/gallery";
  };

  users.users.immich.extraGroups = [ "video" "render" ];

  systemd.services.immich-server.serviceConfig.ReadWritePaths = [
    "/srv/media/gallery"
  ];
}
