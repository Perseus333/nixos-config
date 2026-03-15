{ config, lib, pkgs, ... }:

{
  services.fail2ban = {
    enable = true;
    ignoreIP = [
      "192.168.0.0/16"
      "fd7b:323:3ba9::/48"
    ];
    bantime-increment.enable = true;
    jails = {
      sshd = {
        enabled = true;
        settings = {
          filter = "sshd";
          maxRetry = 3;
          bantime = "1h";
          findtime = "10m";
        };
      };
      forgejo = {
        enabled = true;
        settings = {
          filter = "forgejo-auth";
          logPath = "/var/log/caddy/access.log";
          maxRetry = 3;
          bantime = "1h";
          findtime = "10m";
        };
      };
    };
  };
}

