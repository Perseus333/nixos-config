{ config, ... }:

let
  ports = config.ports;
in {
  caddy = {
    openFirewall = false;
    services = {
      "ai"     = ports.open-webui;
      "img"    = ports.immich;
      "git"    = ports.forgejo;
      "music"  = ports.navidrome;
      "books"  = ports.kavita;
      "cal"    = ports.radicale;
      "home"   = ports.glance;
      "files"  = ports.sftpgo-web;
      "media"  = ports.jellyfin;
      "vault"  = ports.vaultwarden;
      "search" = ports.searxng;
      "sync"   = ports.syncthing;
      "bak"    = ports.backrest;
    };
  };
}
