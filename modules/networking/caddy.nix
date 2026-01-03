{ config, pkgs, lib, ... }:
{

  services.caddy = {
    enable = true;

    virtualHosts."media.perseuslynx.dev".extraConfig = ''
      reverse_proxy 10.8.0.1:8096
    '';
    virtualHosts."git.perseuslynx.dev".extraConfig = ''
      reverse_proxy 127.0.0.1:3000
    '';
    virtualHosts."auth.perseuslynx.dev".extraConfig = ''
      reverse_proxy 127.0.0.1:9091
    '';
    virtualHosts."http://ai.internal".extraConfig = ''
      reverse_proxy 127.0.0.1:1212
    '';
  };
}
