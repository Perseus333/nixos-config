{ config, pkgs, lib, ... }:

{
  services.unbound = {
    enable = true;
    settings = {
      server = {
        # TODO: add DoH
        interface = [ 
          # "127.0.0.1"
          "10.8.0.1"
        ];
        port = 53;
        access-control = [ 
          # "127.0.0.1/32 allow"
          "10.8.0.0/24 allow"
        ];
        root-hints = "${pkgs.dns-root-data}/root.hints";
        harden-glue = true;
        harden-dnssec-stripped = true;
        prefetch = true;
        edns-buffer-size = 1232;
        ratelimit = 100;
        hide-identity = true;
        hide-version = true;
        local-zone = [
          "perseuslynx.dev. transparent"
        ];
        local-data = [
          ''"git.perseuslynx.dev. IN A 10.8.0.1"''
          ''"media.perseuslynx.dev. IN A 10.8.0.1"''
          ''"auth.perseuslynx.dev. IN A 10.8.0.1"''
          ''"ai.perseuslynx.dev. IN A 10.8.0.1"''
          ''"img.perseuslynx.dev. IN A 10.8.0.1"''
          ''"search.perseuslynx.dev. IN A 10.8.0.1"''
          ''"vault.perseuslynx.dev. IN A 10.8.0.1"''
          ''"cal.perseuslynx.dev. IN A 10.8.0.1"''
          ''"files.perseuslynx.dev. IN A 10.8.0.1"''
	  ''"sync.perseuslynx.dev. IN A 10.8.0.1"''
	  ''"bak.perseuslynx.dev. IN A 10.8.0.1"''
        ];
      };
      forward-zone = {
        name = ".";
        forward-addr = [
          "9.9.9.9@853#dns.quad9.net"
          "149.112.112.112@853#dns.quad9.net"
          "1.1.1.1@853#cloudflare-dns.com"
          "2606:4700:4700::1111@853#cloudflare-dns.com"
          "1.0.0.1@853#cloudflare-dns.com"
          "2606:4700:4700::1001@853#cloudflare-dns.com"
        ];
        forward-tls-upstream = true;
        forward-first = false;
      };
    };
  };
}
