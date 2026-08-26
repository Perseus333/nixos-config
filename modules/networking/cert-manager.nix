{ config, lib, ... }:

{
  config = lib.mkIf config.ivy.roles.server.cert-manager.enable {

     sops.secrets.porkbun-dns-token = {
      sopsFile = ../../secrets/services/porkbun-dns-tokens.env;
      format = "dotenv";
      owner = config.users.users.acme.name;
      group = config.users.groups.acme.name;
    };

   security.acme = {
      acceptTerms = true;
      defaults.email = "perseusmith73@gmail.com";

      certs."perseuslynx.dev" = {
        domain           = "*.perseuslynx.dev";
        extraDomainNames = [ "perseuslynx.dev" ];
        dnsProvider      = "porkbun";
        dnsPropagationCheck = true;
        credentialFiles = {
          "PORKBUN_API_KEY_FILE"        = config.sops.secrets.porkbun-dns-token.path;
          "PORKBUN_SECRET_API_KEY_FILE" = config.sops.secrets.porkbun-dns-token.path;
        };
        group            = "caddy";
      };
    };
  };
}
