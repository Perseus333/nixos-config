{ ... }:

{
  caddy = {
    # no need to set proxyTarget as it defaults to 127.0.0.1
    # wg0 is a trusted interface
    openFirewall = false;
    services = {
      "git"    = 3000;
      "media"  = 8096;
      "ai"     = 1212;
      "img"    = 2283;
      "search" = 8888;
      "vault"  = 8222;
      "cal"    = 5232;
      "files"  = 57790;
      "sync"   = 8384;
      "bak"    = 9898;
      "home"   = 5678;
      "music"  = 4533;
      "books"  = 5000;
    };
  };
}
