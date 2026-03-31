{ config, pkgs, lib, ... }:

{
  services.unbound = {
    enable = true;
    settings = {
      server = {
        interface = [ 
          "127.0.0.1"
          "10.8.0.1"
        ];

        port = 53;

        access-control = [ 
          "127.0.0.1/32 allow"
          "10.8.0.0/24 allow"
        ];

        root-hints = "${pkgs.dns-root-data}/root.hints";
        
	# Security/DNNSEC
	harden-glue = true;
        harden-dnssec-stripped = true;
	harden-below-nxdomain = true;
	harden-algo-downgrade = false;
        aggressive-nsec = true;
        val-clean-additional = true;
        ignore-cd-flag = true;
        harden-large-queries = true;
        answer-cookie = true;
        do-ip6 = false;

	use-caps-for-id = true;
        deny-any = true;
        do-not-query-localhost = true;
        private-address = [
          "10.0.0.0/8"
          "172.16.0.0/12"
          "192.168.0.0/16"
          "169.254.0.0/16"
          "fd00::/8"
          "fe80::/10"
        ];
 
	# Privacy
	qname-minimisation = true;
        hide-identity = true;
        hide-version = true;
        hide-trustanchor = true;
        qname-minimisation-strict = true;
        
	# Performance
	prefetch = true;
        edns-buffer-size = 1232;
        ratelimit = 100;
       
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
	  ''"home.perseuslynx.dev. IN A 10.8.0.1"''
	  ''"music.perseuslynx.dev. IN A 10.8.0.1"''
	  ''"books.perseuslynx.dev. IN A 10.8.0.1"''
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
