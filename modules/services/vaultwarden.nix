{ config, lib, pkgs, ... }:

{
  sops.secrets."vaultwarden-env" = {
    owner = config.users.users.vaultwarden.name;
  };
  
  services.vaultwarden = {
    enable = true;
    backupDir = "/srv/bak/vaultwarden";
    environmentFile = config.sops.secrets."vaultwarden-env".path;
    config = {
        DOMAIN = "https://vault.perseuslynx.dev";
        SIGNUPS_ALLOWED = true;
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;
    };
  };
}
