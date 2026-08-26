{config, ... }:

let
  ports = config.ports;
in {
  config.ivy.firewall-zones.zones = {

    # Anyone on the internet has access to these ports
    # Relay: open everywhere
    # Server: open in wg0, and to LAN IPs
    publicPorts = [
      # Keep empty as much as possible
    ];

    # Devices in the LAN or WireGuard
    # Relay: open only in wg0
    # Server: open in wg0, and to LAN IPs
    lanPorts = [
      # Unbound DNS, adblock without WG
      { port = ports.dns;    proto = "tcp"; }
      { port = ports.dns;    proto = "udp"; }
      # For Jellyfin to work in smartTVs
      { port = ports.jellyfin;  proto = "tcp"; }
    ];

    # Only accessible through WireGuard
    # Relay: open only in wg0
    # Server: open only in wg0
    wgOnlyPorts = [
      # Caddy, aka services' interfaces
      { port = ports.https; proto = "tcp"; }
      { port = ports.ssh;   proto = "tcp"; }
      { port = ports.sftpgo-sftp;   proto = "tcp"; }
      { port = ports.sftpgo-webdav; proto = "tcp"; }
    ];
  };
}
