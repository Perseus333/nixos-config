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
          backend = "systemd";
          filter = "forgejo";
          journalmatch = "_SYSTEMD_UNIT=forgejo.service";
          maxretry = 3;
          bantime = "1h";
          findtime = "10m";
        };
      };
    };
  };

  environment.etc."fail2ban/filter.d/forgejo.conf".text = ''
    [Definition]
    failregex = ^.*Failed authentication attempt for .* from <HOST>(?::\d+)?:\s+(?:user's password is invalid|user does not exist).*$
    journalmatch = _SYSTEMD_UNIT=forgejo.service
  '';
}

