{ config, lib, pkgs, ... }:

let
  cfg = config.ivy.firewall-zones;
  z   = cfg.zones;
  roles = config.ivy.roles;

  backendPort = p: if p.targetPort != null then p.targetPort else p.port;

  portEntry = lib.types.submodule {
    options = {
      port = lib.mkOption {
        type        = lib.types.port;
        description = "Public-facing port.";
      };
      proto = lib.mkOption {
        description = "Protocol used, supports only TCP or UDP. For services with both, use two entries";
        type    = lib.types.enum [ "tcp" "udp" ];
        default = "tcp";
      };
      targetPort = lib.mkOption {
        type        = lib.types.nullOr lib.types.port;
        default     = null;
        description = "Remapping, specify only if internal port targeted is different than the public port.";
      };
    };
  };

  tcpPorts = ports: map backendPort (lib.filter (p: p.proto == "tcp") ports);
  udpPorts = ports: map backendPort (lib.filter (p: p.proto == "udp") ports);

in {

  options.ivy.firewall-zones = {

    # Server-specific config
    server = {
      endpointInterface = lib.mkOption {
        type = lib.types.str;
        default = "wg-int";
        description = ''
          Wireguard interface name of endpoint client-server link.
          Should be different than relay.backboneInterface.
        '';
      };
    };

    # Relay-specific config for port forwarding
    relay = {
      target = lib.mkOption {
        type        = lib.types.str;
        default     = "10.8.1.1";
        description = "WireGuard IP of the server that publicPorts are forwarded to.";
      };

      externalInterface = lib.mkOption {
        type        = lib.types.str;
        default     = "ens6";
        description = "Public-facing NIC on the relay host.";
      };

      backboneInterface = lib.mkOption {
        type = lib.types.str;
        default = "wg-bbn";
        description = ''
          Wireguard interface name of private server-relay link.
          Should be different than server.endpointInterface.
        '';
      };

      backbonePort = lib.mkOption {
        type    = lib.types.port;
        default = config.ports.wireguard;
        description = "UDP port at the relay which forwards WG packets to the server.";
      };

      backboneTunnelPort = lib.mkOption {
        type = lib.types.port;
        default = 1559;
        description = "UDP port through which the tunnel of the backbone happens";
      };

      adminInterface = lib.mkOption {
        type = lib.types.str;
        default = "wg-adm";
        description = ''
          Wireguard interface name to perform admin tasks (eg. SSH) on the relay.
          Does not get forwarded to Xiao
        '';
      };

      adminPort = lib.mkOption {
        type = lib.types.port;
        default = 2026;
        description = "Port on which adminInterface listens on.";
      };
    };

    zones = {
      # ZONE: PUBLIC
      # Relay:  accept from any interface
      # Server: accept on backboneInterface without client validation
      publicPorts = lib.mkOption {
        type    = lib.types.listOf portEntry;
        default = [];
        description = "Ports exposed to the public internet.";
      };

      # ZONE: LAN
      # Relay:  not involved
      # Server: accept on wireguard + from IPv4 LAN addresses
      lanPorts = lib.mkOption {
        type    = lib.types.listOf portEntry;
        default = [];
        description = "Ports accessible from the local network and WireGuard clients.";
      };

      # ZONE: WIREGUARD ONLY
      # Relay: accept on relay.wireguardPort
      # Server: accept only through wireguard
      wgOnlyPorts = lib.mkOption {
        type    = lib.types.listOf portEntry;
        default = [];
        description = "Ports accessible only via WireGuard.";
      };
    };
  };

  # ACTUAL CONFIG
  config = lib.mkMerge [

    # General
    {
      networking.firewall = {
        enable                = true;
        logRefusedConnections = true;
      };

      # More readable version of iptables
      networking.nftables.enable = true;
    }

    # SERVER settings: Venti
    (lib.mkIf roles.server.enable {
      networking.firewall = {

        # Ports allowed on venti through the endpoint interface
        # Intended for wg clients
        interfaces.${cfg.server.endpointInterface} = {
          allowedTCPPorts = lib.unique (tcpPorts (z.lanPorts ++ z.wgOnlyPorts));
          allowedUDPPorts = lib.unique (udpPorts (z.lanPorts ++ z.wgOnlyPorts));
        };

        # Ports allowed on xiao via the backbone interface
        # Intended for wg clients + public services to be relayed
        interfaces.${cfg.relay.backboneInterface} = {
          allowedTCPPorts = lib.unique (tcpPorts z.publicPorts);
          allowedUDPPorts = lib.unique (udpPorts z.publicPorts) ++ [ cfg.relay.backbonePort ];
        };

        # Open lanPorts inside the LAN
        extraInputRules = lib.concatStringsSep "\n" (
          (map (p:
            "ip saddr 192.168.0.0/16 ${p.proto} dport ${toString (backendPort p)} accept"
          ) z.lanPorts)
        );
      };
    })

    # RELAY settings: Xiao
    (lib.mkIf roles.relay.enable {
      # Open backbone and admin WG ports in the relay to accept incoming connections 
      networking.firewall = {
        interfaces.${cfg.relay.externalInterface}.allowedUDPPorts = [
          cfg.relay.backbonePort
          cfg.relay.backboneTunnelPort
          cfg.relay.adminPort
        ];

        # The adminInterface is just to enable SSH to the relay
        interfaces.${cfg.relay.adminInterface}.allowedTCPPorts = [ config.ports.ssh ];
      };
    })
  ];
}
