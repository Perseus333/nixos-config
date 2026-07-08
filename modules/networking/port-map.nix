{ lib, ... }:

{
  options.ports = lib.mkOption {
    type = lib.types.attrsOf lib.types.port;
    default = {};
    description = ''
      Unified dictionary mapping service names to their port numbers, eliminating magic numbers.
    '';
  };

  config.ports = {
    # Core Infrastructure
    ssh           = 4684;
    wireguard     = 1558;
    http          = 80;
    https         = 443;
    dns           = 53;
    acme-dns      = 5353;
    acme-dns-api  = 8055;
    initrd-ssh    = 2222;

    # Services
    minecraft     = 25565;
    sftpgo-sftp   = 2022;
    sftpgo-webdav = 10080;

    # Caddy services
    open-webui    = 1212;
    immich        = 2283;
    forgejo       = 3000;
    aint          = 4137;
    navidrome     = 4533;
    kavita        = 5000;
    radicale      = 5232;
    glance        = 5678;
    sftpgo-web    = 5779;
    jellyfin      = 8096;
    vaultwarden   = 8222;
    syncthing     = 8384;
    searxng       = 8888;
    backrest      = 9898;
  };
}
