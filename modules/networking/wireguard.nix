{ config, lib, ... }:

let
  cfg = config.ivy.firewall-zones;
  roles = config.ivy.roles;

  backendPort = p: if p.targetPort != null then p.targetPort else p.port;

  ext = cfg.relay.externalInterface;   # public NIC on relay
  dst = cfg.relay.target;              # server's IP on the backbone link
  bbn = cfg.relay.backboneInterface;   # relay's interface name for the backbone tunnel
  wgPort = cfg.relay.backbonePort;     # public UDP port for clients

  # DNAT rules for regular public services
  dnatPublicRules = lib.concatStringsSep "\n      " (map (p:
    "iifname \"${ext}\" ${p.proto} dport ${toString p.port} dnat to ${dst}:${toString (backendPort p)}"
  ) cfg.zones.publicPorts);

  # DNAT rule for the WireGuard bootstrap port
  dnatWgRule = "iifname \"${ext}\" udp dport ${toString wgPort} dnat to ${dst}:${toString wgPort}";

  # Combine all DNAT rules
  dnatRules = lib.concatStringsSep "\n      " (lib.filter (s: s != "") [ dnatPublicRules dnatWgRule ]);

  # Forward accept rules for public services
  forwardPublicRules = lib.concatStringsSep "\n      " (map (p:
    "iifname \"${ext}\" oifname \"${bbn}\" ip daddr ${dst} ${p.proto} dport ${toString (backendPort p)} accept"
  ) cfg.zones.publicPorts);

  # Forward accept for the WireGuard bootstrap
  forwardWgRule = "iifname \"${ext}\" oifname \"${bbn}\" ip daddr ${dst} udp dport ${toString wgPort} accept";

  # Combine all forward accept rules
  forwardRules = lib.concatStringsSep "\n      " (lib.filter (s: s != "") [ forwardPublicRules forwardWgRule ]);

in {

  imports = [
    ./firewall-zones.nix
    ./fw-zones-conf.nix
  ];

  config = lib.mkMerge [

    # SERVER:
    # The client-facing WireGuard interface must listen on the relay's bootstrap port.
    # Clients will send their handshakes to that port on the relay, which forwards them here.
    (lib.mkIf roles.server.enable {
      networking.wireguard.interfaces.${cfg.server.endpointInterface}.listenPort = cfg.relay.backbonePort;
    })

    # RELAY:
    (lib.mkIf roles.relay.enable {

      # Enable IP forwarding so the relay can pass packets between interfaces
      boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

      # nftables table for relaying public traffic and the WireGuard bootstrap
      networking.nftables.tables.wg-relay = {
        family = "ip";
        content = ''
          # Redirect to the server
          chain prerouting {
            type nat hook prerouting priority dstnat; policy accept;
            ${dnatRules}
          }

          # Ensure Venti routes replies back to the relay instead of the internet IP
          chain postrouting {
            type nat hook postrouting priority srcnat; policy accept;
            # Masquerade all traffic leaving via the backbone interface towards the server.
            # This ensures reply packets return to the relay, not directly to the client.
            oifname "${bbn}" ip daddr ${dst} masquerade
          }

          # Foward only what's strictly allowed, drop all else 
          chain forward {
            type filter hook forward priority filter; policy drop;
            ct state established,related accept
            ${forwardRules}
          }
        '';
      };
    })
  ];
}
