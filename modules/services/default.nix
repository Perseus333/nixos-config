{ ... }:
{
  # Eventually replace with custom cfg
  imports = [
    ../../modules/services/backrest.nix
    ../../modules/services/forgejo.nix
    ../../modules/services/glance.nix
    ../../modules/services/immich.nix
    ../../modules/services/jellyfin.nix
    ../../modules/services/kavita.nix
    ../../modules/services/minecraft.nix
    ../../modules/services/navidrome.nix
    ../../modules/services/open-webui.nix
    #../../modules/services/radicale.nix
    ../../modules/services/samba.nix
    ../../modules/services/searx.nix
    ../../modules/services/sftpgo.nix
    #../../modules/services/syncthing.nix
    ../../modules/services/vaultwarden.nix
    ../../modules/services/ytdl-sub.nix
  ];
}
