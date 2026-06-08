{config, lib, pkgs, ...}:

{
  sops.secrets."kavita-token" = {
    owner = "kavita";
  };

  services.kavita = {
    enable = true;
    dataDir = "/var/lib/kavita";
    tokenKeyFile = config.sops.secrets."kavita-token".path;
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/kavita      0750 non kavita -"
    "d /srv/media/grayscale 0750 non kavita -"
    "d /srv/media/lectern   0750 non kavita -"
  ];
}
