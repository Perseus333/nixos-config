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

    virtualHosts."vault.perseuslynx.dev" = {
      useACMEHost = "perseuslynx.dev";
      extraConfig = "reverse_proxy 127.0.0.1:8222";
    };
    virtualHosts."cal.perseuslynx.dev" = {
      useACMEHost = "perseuslynx.dev";
      extraConfig = "reverse_proxy 127.0.0.1:5232";
    };
    virtualHosts."files.perseuslynx.dev" = {
      useACMEHost = "perseuslynx.dev";
      extraConfig = "reverse_proxy 127.0.0.1:57790";
    };
    virtualHosts."sync.perseuslynx.dev" = {
      useACMEHost = "perseuslynx.dev";
      extraConfig = "reverse_proxy 127.0.0.1:8384";
    };
    virtualHosts."bak.perseuslynx.dev" = {
      useACMEHost = "perseuslynx.dev";
      extraConfig = "reverse_proxy 127.0.0.1:9898";
    };
  };
}
