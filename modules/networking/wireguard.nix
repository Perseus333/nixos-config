{ config, lib, ... }:

let
  cfg = config.firewall-zones;

  backendPort = p: if p.targetPort != null then p.targetPort else p.port;

  ext = cfg.relay.externalInterface;
  dst = cfg.relay.target;

  dnatRules = lib.concatStringsSep "\n      " (map (p:
    "iifname \"${ext}\" ${p.proto} dport ${toString p.port} dnat to ${dst}:${toString (backendPort p)}"
  ) cfg.zones.publicPorts);

  masqRules = lib.concatStringsSep "\n      " (map (p:
    "oifname \"wg0\" ip daddr ${dst} ${p.proto} dport ${toString (backendPort p)} masquerade"
  ) cfg.zones.publicPorts);

in {

  config = lib.mkMerge [

    {
      networking.wireguard.interfaces.wg0.listenPort = 1558;
      networking.firewall.allowedUDPPorts = [ 1558 ];
    }

    # RELAY ONLY
    (lib.mkIf (cfg.role == "relay") {

      # Required for the relay to forward packets between interfaces
      boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

      # More readable version of iptables
      networking.nftables.enable = true;

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
            ${masqRules}
          }
        '';
      };
    })
  ];
}
