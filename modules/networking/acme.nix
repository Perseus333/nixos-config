{ config, pkgs, lib, ... }:

let
  acmeDnsEnv = pkgs.writeText "acme-dns-env" ''
    ACME_DNS_API_BASE=http://127.0.0.1:${toString config.ports.acme-dns-api}
    ACME_DNS_STORAGE_PATH=/var/lib/acme/acme-dns.json
  '';
in
{
  security.acme = {
    acceptTerms = true;
    defaults.email = "perseusmith73@gmail.com";

    certs."perseuslynx.dev" = {
      domain           = "*.perseuslynx.dev";
      extraDomainNames = [ "perseuslynx.dev" ];
      dnsProvider      = "acme-dns";
      dnsPropagationCheck = false;
      dnsResolver = "127.0.0.1:${toString config.ports.dns}";
      environmentFile  = acmeDnsEnv;
      group            = "caddy";
    };
  };
}
