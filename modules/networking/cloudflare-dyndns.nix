{ config, lib, pkgs, ... }:

{
  sops.secrets."cloudflare-dns-token-plain" = {};
  services.cloudflare-dyndns = {
    enable = true;
    apiTokenFile = config.sops.secrets."cloudflare-dns-token-plain".path;
    domains = [ "dyn.perseuslynx.dev" ];
    ipv4 = true;
    ipv6 = false;
  };
}
