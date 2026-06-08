{ config, lib, pkgs, ...}:

{
  sops.secrets."radicale-creds" = {
    owner = "radicale";
  };

  services.radicale = {
    enable = true;
    settings = {
      auth = {
        type = "htpasswd";
        htpasswd_filename = config.sops.secrets."radicale-creds".path;
        htpasswd_encryption = "bcrypt";
      };
      storage = {
        type = "multifilesystem";
        filesystem_folder = "/var/lib/radicale";
      };
    };
  };
}
