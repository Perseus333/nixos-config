{ ... }:

{
  caddy = {
    openFirewall = false;
    services = {
      "ai"     = 1212; # Open WebUI
      "img"    = 2283; # Immich
      "git"    = 3000; # Forgejo
      "music"  = 4533; # Navidrome
      "books"  = 5000; # Kavita
      "cal"    = 5232; # Radicale
      "home"   = 5678; # Glance
      "files"  = 5779; # SFTPGo
      "media"  = 8096; # Jellyfin
      "vault"  = 8222; # Vaultwarden
      "search" = 8888; # SearXNG
      "sync"   = 8384; # Syncthing
      "bak"    = 9898; # Backrest
    };
  };
}
