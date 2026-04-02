{ config, pkgs, lib, ... }:

let
  baseDomain = "perseuslynx.dev";
  
  servicesMap = {
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

  mkDomain = sub: if sub == "" then baseDomain else "${sub}.${baseDomain}";

in {
  services.caddy = {
    enable = true;
    virtualHosts = lib.mapAttrs' (sub: port: lib.nameValuePair (mkDomain sub) {
      useACMEHost = baseDomain;
      extraConfig = "reverse_proxy 127.0.0.1:${toString port}";
    }) servicesMap;
  };

  systemd.services.caddy.serviceConfig = {
    AmbientCapabilities  = lib.mkForce [ "CAP_NET_BIND_SERVICE" ];
    CapabilityBoundingSet = lib.mkForce [ "CAP_NET_BIND_SERVICE" ];
  };
}
