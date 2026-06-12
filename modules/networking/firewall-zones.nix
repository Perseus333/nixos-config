{ config, lib, pkgs, ... }:

let
  cfg = config.firewall-zones;
  z   = cfg.zones;

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

  options.firewall-zones = {

    role = lib.mkOption {
      type    = lib.types.enum [ "relay" "server" "none" ];
      default = "none";
      description = ''
        Network role of this machine:
          "server": home server (Venti). Opens all zone ports on wg0, lanPorts are also accessible from 192.168.0.0/16.
          "relay":  public VPS (Xiao) to go through CGNAT, forwards everything, only allows SSH.
          "none":   no zone-based rules.
      '';
    };

    # Relay-specific config for port forwarding
    relay = {
      target = lib.mkOption {
        type        = lib.types.str;
        default     = "10.8.0.1";
        description = "WireGuard IP of the server that publicPorts are forwarded to.";
      };
      externalInterface = lib.mkOption {
        type        = lib.types.str;
        default     = "ens6";
        description = "Public-facing NIC on the relay host.";
      };
    };

    zones = {
      # ZONE: PUBLIC
      # Relay:  accept from any interface
      # Server: accept on wg0 using targetPort
      publicPorts = lib.mkOption {
        type    = lib.types.listOf portEntry;
        default = [];
        description = "Ports exposed to the public internet.";
      };

      # ZONE: LAN
      # Relay:  not involved
      # Server: accept on wg0 + from IPv4 LAN addresses
      lanPorts = lib.mkOption {
        type    = lib.types.listOf portEntry;
        default = [];
        description = "Ports accessible from the local network and WireGuard clients.";
      };

      # ZONE: WIREGUARD ONLY
      # Both roles: accept on wg0 only.
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
    }

    # SERVER: Venti
    (lib.mkIf (cfg.role == "server") {
      networking.firewall = {

        interfaces.wg0 = {
          # The server opens all specified target ports on wg0
          allowedTCPPorts = lib.unique (tcpPorts (z.publicPorts ++ z.lanPorts ++ z.wgOnlyPorts));
          allowedUDPPorts = lib.unique (udpPorts (z.publicPorts ++ z.lanPorts ++ z.wgOnlyPorts));
        };

        # Open lanPorts inside the LAN
        extraCommands = lib.concatStringsSep "\n" (
          (map (p:
            "${pkgs.iptables}/bin/iptables -A INPUT -s 192.168.0.0/16 -p ${p.proto} --dport ${toString (backendPort p)} -j ACCEPT"
          ) z.lanPorts)
        );
      };
    })

    # RELAY: Xiao
    (lib.mkIf (cfg.role == "relay") {
      networking.firewall = {
        # Only SSH needs to be open on wg0 since the other ports are forwarded
        interfaces.wg0.allowedTCPPorts = [ config.ports.ssh ];
      };
    })
  ];
}
