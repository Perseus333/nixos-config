{config, lib, pkgs, ... }:

{
  sops.secrets."cloudflare-dns-token" = {
    owner = "acme";
    restartUnits = [ "acme-perseuslynx.dev.service" ];
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "perseusmith73@gmail.com";

    certs."perseuslynx.dev" = {
      group = config.services.caddy.group;
      domain = "perseuslynx.dev";
      extraDomainNames = [ "*.perseuslynx.dev" ];
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      dnsPropagationCheck = true;
      environmentFile = config.sops.secrets."cloudflare-dns-token".path;
    };
  };

  users.groups.acme = {};
  users.users.caddy.extraGroups = [ "acme" ];
}
