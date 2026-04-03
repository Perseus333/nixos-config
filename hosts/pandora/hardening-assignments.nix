{ ... }:

{
  harden.strict = [
    "vaultwarden"
    "radicale"
    "searx-init"
    "redis-searx"
    "syncthing"
    "sftpgo"
    "glance"
    "backrest"
    "navidrome"
  ];

  harden.network = [
    "caddy"
    "unbound"
    "authelia-main"
    "cloudflared"
    "open-webui"
    "ollama"
    "fail2ban"
    "forgejo"
    "jellyfin"
    "minecraft-server-survival"
    "immich-server"
    "immich-machine-learning"
    "kavita"
    "ytdl-sub"
  ];
}
