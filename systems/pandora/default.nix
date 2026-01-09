{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/base/nix.nix
    ../../modules/base/boot.nix
    ../../modules/base/security.nix
    ../../modules/base/users.nix
    ../../modules/base/zfs.nix
    ../../modules/networking/acme.nix
    ../../modules/networking/caddy.nix
    ../../modules/networking/cloudflared.nix
    ../../modules/networking/firewall.nix
    ../../modules/networking/ssh.nix
    ../../modules/networking/ethernet.nix
    ../../modules/networking/wireless.nix
    ../../modules/networking/fail2ban.nix
    ../../modules/networking/wireguard.nix
    ../../modules/networking/unbound.nix
    ../../modules/services/authelia.nix
    ../../modules/services/forgejo.nix
    ../../modules/services/immich.nix
    ../../modules/services/jellyfin.nix
    ../../modules/services/open-webui.nix
    ../../modules/services/radicale.nix
    ../../modules/services/samba.nix
    ../../modules/services/searx.nix
    ../../modules/services/vaultwarden.nix
  ];

  # Host identification
  networking = {
    hostName = "pandora";
    hostId = "e281e2d1";
  };

  # Timezone
  time.timeZone = "Europe/London";

  # System packages
  environment.systemPackages = with pkgs; [
    vim 
    wget
    wpa_supplicant
    networkmanager
    dhcpcd
    iproute2
    iputils
    git
    tree
    tmux
    age
    sops
    home-manager
    dig
    wireguard-tools
    btop
    cloudflared
    forgejo
    forgejo-cli
    authelia
    open-webui
    immich
    immich-cli
  ];

  # Simple security logs
  services.journald = {
    extraConfig = ''
      SystemMaxUse=500M
    '';
  };

  system.stateVersion = "25.05";
}
