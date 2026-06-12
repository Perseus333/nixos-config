{config, ... }:

{
  config.firewall-zones.zones = {

    # Anyone on the internet has access to these ports
    # Relay: open everywhere
    # Server: open in wg0, and to LAN IPs
    publicPorts = [
      # acme-dns DNS-01 challenge solver
      { port = 53; proto = "tcp"; targetPort = 5353; }
      { port = 53; proto = "udp"; targetPort = 5353; }
      # MC server
      { port = 25565; proto = "tcp";  }
    ];

    # Devices in the LAN or WireGuard
    # Relay: open only in wg0
    # Server: open in wg0, and to LAN IPs
    lanPorts = [
      # Unbound DNS, adblock without WG
      { port = 53;    proto = "tcp"; }
      { port = 53;    proto = "udp"; }
      # Jellyfin, to work in smartTVs
      { port = 8096;  proto = "tcp"; }
    ];

    # Only accessible through WireGuard
    # Relay: open only in wg0
    # Server: open only in wg0
    wgOnlyPorts = [
      # Caddy, aka services' interfaces
      { port = 443;   proto = "tcp"; }
      # SFTPGo SFTP
      { port = 2022;  proto = "tcp"; }
      # SFTPGo WebDAV
      { port = 10080; proto = "tcp"; }
    ];
  };
}
