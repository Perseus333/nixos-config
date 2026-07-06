{ config, pkgs, ... }:

{
  services.sftpgo = {
    enable = true;
    settings = {
      httpd = {
        bindings = [{
          port = config.ports.sftpgo-web;
          address = "127.0.0.1";
          enable_web_admin = true;
          enable_web_client = true;
        }];
      };

      sftpd.bindings = [{
        port = config.ports.sftpgo-sftp;
        address = "10.8.0.1";
      }];

      webdavd.bindings = [{
        port = config.ports.sftpgo-webdav;
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

  users.users.ytdl-sub.extraGroups = [ "private-files" ];
}
