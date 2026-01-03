{ config, pkgs, ... }:

{
  sops.secrets.cloudflare-dns-token = {
    owner = config.users.users.acme.name;
    group = config.users.groups.acme.name;
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "perseusmith73@gmail.com";

    certs."perseuslynx.dev" = {
      domain = "*.perseuslynx.dev";
      extraDomainNames = [ "perseuslynx.dev" ];
      dnsProvider = "cloudflare";
      dnsPropagationCheck = true;
      credentialsFile = config.sops.secrets.cloudflare-dns-token.path;
      
      group = "caddy"; 
    };
  };
}
