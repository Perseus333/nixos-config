{ config, pkgs, ... }:

{
  sops.secrets."cloudflared-cert" = {
    format = "binary";
    sopsFile = ../../secrets/services/cloudflared-cert.pem;
  };

  sops.secrets."cloudflared-creds" = {
    format = "binary";
    sopsFile = ../../secrets/services/cloudflared-creds.json;
    owner = "cloudflared";
    group = "cloudflared";
    mode = "0400";
  };

  users.users.cloudflared = {
    isSystemUser = true;
    group = "cloudflared";
  };

  users.groups.cloudflared = {};

  services.cloudflared = {
    enable = true;
    certificateFile = config.sops.secrets."cloudflared-cert".path;
    tunnels = {
      "pandora-main" = {
        ingress = {
          "media.perseuslynx.dev" = "http://10.8.0.1:8096";
          "git.perseuslynx.dev"   = "http://localhost:3000";
        };
        default = "http_status:404";
        credentialsFile = config.sops.secrets."cloudflared-creds".path;
      };
    };
  };
}

