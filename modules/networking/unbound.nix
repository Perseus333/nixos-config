{ config, pkgs, lib, ... }:

{
  services.unbound = {
    enable = true;
    settings = {
      server = {
        # TODO: add DoH
        interface = [ "10.8.0.1" ];
        port = 53;
        access-control = [ "10.8.0.0/24 allow" ];
        harden-glue = true;
        harden-dnssec-stripped = true;
        prefetch = true;
        edns-buffer-size = 1232;
        ratelimit = 100;
        hide-identity = true;
        hide-version = true;
        local-zone = [
          "perseuslynx.dev. static"
        ];
        local-data = [
          ''"placeholder.perseuslynx.dev. IN A 10.8.0.1"''
        ];
      };
      forward-zone = [
        {
          name = ".";
          forward-addr = [
            "9.9.9.9#dns.quad9.net"
            "149.112.112.112#dns.quad9.net"
          ];
          forward-tls-upstream = true;
        }
      ];
    };
  };
}
