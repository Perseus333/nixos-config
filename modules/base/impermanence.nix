{ config, lib, pkgs, ... }:

{
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/nixos"
      "/var/lib/systemd"
      "/var/log"
      "/var/lib/backrest"
      "/var/lib/open-webui"
      "/var/lib/ollama"
      "/var/lib/vaultwarden"
      "/var/lib/forgejo"
      "/var/lib/immich"
      "/var/lib/syncthing"
      "/var/lib/authelia-main"
      "/var/lib/caddy"
      "/var/lib/acme"
      "/var/lib/sftpgo"
      "/var/lib/navidrome"
      "/var/lib/postgresql"
      "/var/lib/jellyfin"
      "/etc/ssh"
    ];
    files = [
      "/etc/machine-id"
    ];
  };
}
