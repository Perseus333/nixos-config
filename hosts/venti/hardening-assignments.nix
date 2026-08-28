{ ... }:

{
  ivy.hardening.services = {
    # By default all contain default settings
    aint                    = [ "stateless" "usesNspawn" ];
    # backrest              = # custom pkg, individual hardening
    caddy                   = [ "stateless" "lowPortBinding" "needsInternet" ];
    forgejo                 = [ ];
    glance                  = [ "stateless" "usesNspawn" "needsInternet" ];
    immich-machine-learning = [ "usesJIT" "needsProc" ];
    immich-redis            = [ "stateless" ];
    immich-server           = [ "usesJIT" ];
    immich-system           = [ "usesJIT" ];
    jellyfin                = [ "usesJIT" ];
    kavita                  = [ "usesJIT" "unManagedUsers" ];
    navidrome               = [ ];
    radicale                = [ ];
    redis-searx             = [ "stateless" ];
    searx-init              = [ "unManagedUsers" "needsInternet" ];
    sftpgo                  = [ "unManagedUsers" ];
    syncthing               = [ "preserveGUID" ];
    syncthing-init          = [ "stateless" ];
    # unbound               = [ "lowPortBinding" ];
    vaultwarden             = [ ];
    vikunja                 = [ "stateless" "usesNspawn" ];
    # wireguard             = [ "netAdmin" ];
  };
}
