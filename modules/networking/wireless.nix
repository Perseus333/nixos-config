{ config, lib, pkgs, ... }:

{
  sops.secrets."wifi-pwd" = {};

  sops.templates."wireless-secrets" = {
    content = ''
      psk=${config.sops.placeholder.wifi-pwd}
    '';
    restartUnits = [ "wpa_supplicant.service" ];
  };

  networking = {
    wireless = {
      enable = true;
      secretsFile = config.sops.templates."wireless-secrets".path;
      networks."SKYDRNXQ" = {
        pskRaw = "ext:psk";
      };
    };
    useDHCP = true;
    nameservers = [ "10.8.0.1" ];
  };
  environment.etc = {
    "resolv.conf".text = "#Contents overriten by NixOS config\nnameserver 10.8.0.1\n";
  };

  systemd.services.wpa_supplicant = {
    after = [ "sys-subsystem-net-devices-wlp5s0.device" ];
    bindsTo = [ "sys-subsystem-net-devices-wlp5s0.device" ];
    unitConfig.RequiresMountsFor = [ "/run/secrets/rendered" ];
  };
}
