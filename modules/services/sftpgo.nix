{ config, pkgs, ... }:

{
  services.sftpgo = {
    enable = true;
    settings = {
      httpd = {
        bindings = [{
          port = 57790;
          address = "127.0.0.1";
          enable_web_admin = true;
          enable_web_client = true;
        }];
      };

      sftpd.bindings = [{
        port = 2022;
        address = "10.8.0.1";
      }];

      webdavd.bindings = [{
        port = 10080;
        address = "10.8.0.1";
      }];

      data_provider = {
        driver = "sqlite";
        name = "/var/lib/sftpgo/sftpgo.db";
      };
    };
    settings.common.defender = {
      enabled = true;
      ban_time = 30;
      ban_limit = 3;
    };
  };

  networking.firewall.allowedTCPPorts = [ 2022 10080 ];
}
