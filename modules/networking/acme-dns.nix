{ config, lib, pkgs, ... }:

{
  services.acme-dns = {
    enable = true;
    settings = {
      general = {
        listen   = "0.0.0.0:5353";
        protocol = "both";
        domain   = "auth.perseuslynx.dev";
        nsname   = "acme-ns.perseuslynx.dev";
        nsadmin  = "admin.perseuslynx.dev";
        records = [
          "auth.perseuslynx.dev. A 87.106.83.12"
          "acme-ns.perseuslynx.dev. A 87.106.83.12"
        ];
        debug = false;
      };
      database = {
        engine     = "sqlite";
        connection = "/var/lib/acme-dns/acme-dns.db";
      };
      api = {
        ip                   = "127.0.0.1";
        port                 = 8055;
        disable_registration = true; # Set to false for registration
        tls                  = "none";
        corsorigins          = [ "*" ];
        use_header           = false;
      };
      logconfig = {
        loglevel  = "info";
        logtype   = "stdout";
        logformat = "text";
      };
    };
  };
}
