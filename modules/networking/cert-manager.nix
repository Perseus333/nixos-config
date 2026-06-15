{ config, lib, pkgs, ... }:

let
  acmeDnsEnv = pkgs.writeText "acme-dns-env" ''
    ACME_DNS_API_BASE=http://127.0.0.1:${toString config.ports.acme-dns-api}
    ACME_DNS_STORAGE_PATH=/var/lib/acme/acme-dns.json
  '';
in
{
  config = lib.mkIf config.ivy.roles.server.cert-manager.enable {
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

    services.acme-dns = {
      enable = true;
      settings = {
        general = {
          listen   = "0.0.0.0:${toString config.ports.acme-dns}";
          protocol = "both";
          domain   = "auth.perseuslynx.dev";
          nsname   = "acme-ns.perseuslynx.dev";
          nsadmin  = "admin.perseuslynx.dev";
          records = [
            "auth.perseuslynx.dev. A 87.106.83.12"
            "acme-ns.perseuslynx.dev. A 87.106.83.12"
          ];
          debug = false;
        };
        database = {
          engine     = "sqlite";
          connection = "/var/lib/acme-dns/acme-dns.db";
        };
        api = {
          ip                   = "127.0.0.1";
          port                 = config.ports.acme-dns-api;
          disable_registration = true; # Set to false for registration
          tls                  = "none";
          corsorigins          = [ "*" ];
          use_header           = false;
        };
        logconfig = {
          loglevel  = "info";
          logtype   = "stdout";
          logformat = "text";
        };
      };
    };
  };
}
