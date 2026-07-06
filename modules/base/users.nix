{ config, lib, pkgs, ... }:

{
  sops.secrets.non-pwd-hash = {
    neededForUsers = true;
  };
  users.users.non = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPasswordFile = config.sops.secrets.non-pwd-hash.path;
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIO0nWPCSX+E6Ze1tyHUZABf4gkfTjcxs5fXuqy6EfoYkAAAABHNzaDo= perseus@mycenae"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIPdXXZV1q964neYidTdL/fdyPuIhYzn353qe/G2BP4GvAAAABHNzaDo= perseus@mycenae"
    ];
  };

  # No root user
  users.users.root.hashedPassword = "!";

  users.groups = {
    private-files = {};
    media-public = {};    # Media publicly available on the internet
    media-private = {};   # Personal media files
  };

  systemd.tmpfiles.rules = [
    # Allows non to access the sops-key
    "d  /var/lib/sops-nix           0700  non  users          -  -"

    "d  /srv/files                  2770  non  private-files  -  -"

    "d  /srv/media                  0755  non  users          -  -"
    "d  /srv/media/cinema           2770  non  media-public   -  -"
    "d  /srv/media/harmonics        2770  non  media-public   -  -"
    "d  /srv/media/lectern          2770  non  media-public   -  -"
    "d  /srv/media/grayscale        2770  non  media-public   -  -"
    "d  /srv/media/genshin          2770  non  media-public   -  -"
    "d  /srv/media/misc             2770  non  media-public   -  -"

    "d  /srv/media/gallery          2770  non  media-private  -  -"
    "d  /srv/media/immich-ingest    2770  non  media-private  -  -"
  ];
}
