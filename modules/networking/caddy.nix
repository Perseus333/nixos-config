{ config, lib, ... }:

let
  cfg = config.caddy;
  baseDomain = "perseuslynx.dev";
  mkDomain = sub: if sub == "" then baseDomain else "${sub}.${baseDomain}";
in {
  options.caddy = {
    proxyTarget = lib.mkOption {
      type    = lib.types.str;
      default = "127.0.0.1";
      description = "Host to reverse proxy to. Use 127.0.0.1 for local services, or a WireGuard IP for remote ones.";
    };

    services = lib.mkOption {
      type        = lib.types.attrsOf lib.types.port;
      default     = {};
      description = "Dictionary to link subdomain and it's port. Empty string key maps to the bare domain.";
      example     = { "git" = 3000; "vault" = 8222; };
    };

    openFirewall = lib.mkOption {
      type    = lib.types.bool;
      default = false;
      description = "Whether to open port 443 in the firewall. Enable on internet-facing hosts.";
    };
  };

  config = lib.mkIf (cfg.services != {}) {
    services.caddy = {
      enable = true;
      virtualHosts = lib.mapAttrs' (sub: port:
        lib.nameValuePair (mkDomain sub) {
          useACMEHost = baseDomain;
          extraConfig = "reverse_proxy ${cfg.proxyTarget}:${toString port}";
        }
      ) cfg.services;
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ 443 ];

    services.caddy.globalConfig = ''
      auto_https disable_redirects
    '';

    systemd.services.caddy.serviceConfig = {
      AmbientCapabilities   = lib.mkForce [ "CAP_NET_BIND_SERVICE" ];
      CapabilityBoundingSet = lib.mkForce [ "CAP_NET_BIND_SERVICE" ];
    };
  };
}
