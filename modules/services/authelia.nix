{ config, lib, pkgs, ... }:

{
  services.authelia.instances.main = {
    enable = true;
    
    secrets = {
      jwtSecretFile = "/var/lib/authelia-main/jwt_secret";
      storageEncryptionKeyFile = "/var/lib/authelia-main/storage_encryption_key";
    };

    settings = {
      theme = "auto";
      default_2fa_method = "totp";
      server.address = "0.0.0.0:9091";      

      log.level = "info";

      authentication_backend = {
        file = {
          path = "/var/lib/authelia-main/users_database.yml";
        };
      };

      access_control = {
        default_policy = "bypass";
        rules = [
          {
            domain = [
              #"media.perseuslynx.dev"
              "immich.perseuslynx.dev"
            ];
            policy = "two_factor";
          }
        ];
      };

      session = {
        domain = "perseuslynx.dev"; # Root domain
        expiration = "1h";
        inactivity = "5m";
      };

      storage.local.path = "/var/lib/authelia-main/db.sqlite3";

      notifier.filesystem.filename = "/var/lib/authelia-main/notifications.txt";
      # For production, use SMTP instead:
      # notifier.smtp = {
      #   host = "smtp.example.com";
      #   port = 587;
      #   username = "user";
      #   password = "pass";
      #   sender = "authelia@yourdomain.com";
      # };
    };
  };

  # Generate secrets on first run
  system.activationScripts.authelia-secrets = ''
    mkdir -p /var/lib/authelia
    if [ ! -f /var/lib/authelia/jwt_secret ]; then
      ${pkgs.openssl}/bin/openssl rand -hex 32 > /var/lib/authelia/jwt_secret
    fi
    if [ ! -f /var/lib/authelia/storage_encryption_key ]; then
      ${pkgs.openssl}/bin/openssl rand -hex 32 > /var/lib/authelia/storage_encryption_key
    fi
  '';
}
