{ ... }:

{
  ivy.hardening.services = {
    # By default all contain default settings
    aint                    = [ "stateless" "usesNspawn" ];
    # backrest              = # custom pkg, individual hardening
    caddy                   = [ "stateless" "lowPortBinding" ];
    forgejo                 = [ ];
    glance                  = [ "stateless" "usesNspawn" ];
    immich-machine-learning = [ "usesJIT" ];
    immich-redis            = [ "stateless" ];
    immich-server           = [ "usesJIT" ];
    immich-system           = [ "usesJIT" ];
    jellyfin                = [ "usesJIT" ];
    kavita                  = [ "usesJIT" "unManagedUsers" ];
    navidrome               = [ ];
    radicale                = [ ];
    redis-searx             = [ "stateless" ];
    searx-init              = [ "unManagedUsers" ];
    sftpgo                  = [ "unManagedUsers" ];
    syncthing               = [ "preserveGUID" ];
    syncthing-init          = [ "stateless" ];
    # unbound               = [ "lowPortBinding" ];
    vaultwarden             = [ ];
    vikunja                 = [ "stateless" "usesNspawn" ];
    # wireguard             = [ "netAdmin" ];
  };
}
