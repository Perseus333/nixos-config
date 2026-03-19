{config, lib, pkgs, ...}:

{
  services.navidrome = {
    enable = true;
    settings = {
      MusicFolder = "/srv/media/harmonics";
    };
  };
}
