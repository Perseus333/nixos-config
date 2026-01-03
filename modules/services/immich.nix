{config, lib, pkgs, ...}:

{
  services.immich = {
    enable = true;
    host = "127.0.0.1";
    port = 2283;
    mediaLocation = "/srv/media/gallery";
  };

  users.users.immich.extraGroups = [ "video" "render" ];
}
