{ config, pkgs, lib, ... }:

{
  services.caddy = {
    enable = true;

    virtualHosts."perseuslynx.dev" = {
      useACMEHost = "perseuslynx.dev";
    };
    virtualHosts."git.perseuslynx.dev" = {
      useACMEHost = "perseuslynx.dev"; 
      extraConfig = "reverse_proxy 127.0.0.1:3000";
    };

    virtualHosts."auth.perseuslynx.dev" = {
      useACMEHost = "perseuslynx.dev";
      extraConfig = "reverse_proxy 127.0.0.1:9091";
    };

    virtualHosts."media.perseuslynx.dev" = {
      useACMEHost = "perseuslynx.dev"; 
      extraConfig = "reverse_proxy 127.0.0.1:8096";
    };

    virtualHosts."ai.perseuslynx.dev" = {
      useACMEHost = "perseuslynx.dev";
      extraConfig = "reverse_proxy 127.0.0.1:1212";
    };

    virtualHosts."img.perseuslynx.dev" = {
      useACMEHost = "perseuslynx.dev";
      extraConfig = "reverse_proxy 127.0.0.1:2283";
    };

    virtualHosts."search.perseuslynx.dev" = {
      useACMEHost = "perseuslynx.dev";
      extraConfig = "reverse_proxy 127.0.0.1:8888";
    };
  };
}
