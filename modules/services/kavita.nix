{config, lib, pkgs, ...}:

{
  sops.secrets."kavita-token" = {
    owner = "kavita";
  };

  services.kavita = {
    enable = true;
    settings.Port = config.ports.kavita;
    dataDir = "/var/lib/kavita";
    tokenKeyFile = config.sops.secrets."kavita-token".path;
  };

  users.users.kavita.extraGroups = [ "media-public" ];

  systemd.tmpfiles.rules = [
    "d /var/lib/kavita      0750 non kavita -"
    "d /srv/media/grayscale 0750 non kavita -"
    "d /srv/media/lectern   0750 non kavita -"
  ];

  systemd.services.kavita = {
    serviceConfig = {
      StateDirectory = "kavita";
      ReadWritePaths = [ "/var/lib/kavita" ];
    };
  };
}
