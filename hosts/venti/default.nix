{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./caddy-conf.nix
    ./disko.nix
    ./hardening-assignments.nix
    ./impermanence.nix
    ./hardware.nix
    ./wireguard.nix
    ../../modules/base/boot.nix
    ../../modules/base/home.nix
    ../../modules/base/impermanence.nix
    ../../modules/base/nix.nix
    ../../modules/base/packages.nix
    ../../modules/base/security.nix
    ../../modules/base/service-hardening.nix
    ../../modules/base/users.nix
    ../../modules/base/zfs.nix
    ../../modules/networking/acme.nix
    ../../modules/networking/acme-dns.nix
    ../../modules/networking/blocklist.nix
    ../../modules/networking/caddy.nix
    ../../modules/networking/ethernet.nix
    ../../modules/networking/fail2ban.nix
    ../../modules/networking/port-map.nix
    ../../modules/networking/ssh.nix
    ../../modules/networking/unbound.nix
    ../../modules/networking/wireless.nix
    ../../modules/networking/wireguard.nix
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

  firewall-zones.role = "server";

  # Host identification
  networking = {
    hostName = "venti";
    hostId = "e281e2d1";
  };

  # Host-specific packages
  environment.systemPackages = with pkgs; [
    forgejo
    forgejo-cli
    authelia
    open-webui
    immich-cli
    backrest
  ];

  # Timezone
  time.timeZone = "Europe/London";

  # Simple security logs
  services.journald = {
    extraConfig = ''
      SystemMaxUse=500M
    '';
  };

  system.stateVersion = "25.05";
}
