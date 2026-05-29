{ config, lib, pkgs, ... }:

{
  sops.secrets."wifi-ssid-1" = {};
  sops.secrets."wifi-psk-1" = {};
  sops.secrets."wifi-ssid-2" = {};
  sops.secrets."wifi-psk-2" = {};

  sops.templates."wireless-secrets" = {
    content = ''
      ssid_1=${config.sops.placeholder.wifi-ssid-1}
      psk_1=${config.sops.placeholder.wifi-psk-1}
      ssid_2=${config.sops.placeholder.wifi-ssid-2}
      psk_2=${config.sops.placeholder.wifi-psk-2}
    '';
    restartUnits = [ "wpa_supplicant.service" ];
  };

  networking = {
    wireless = {
      enable = true;
      secretsFile = config.sops.templates."wireless-secrets".path;
      networks = {
        "network1" = {
          ssid = "ext:ssid_1";
          pskRaw = "ext:psk_1";
        };
        "network2" = {
          ssid = "ext:ssid_2";
          pskRaw = "ext:psk_2";
        };
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
  
  # required by syncthing
  boot.kernel.sysctl = {
    "net.core.rmem_max" = 7340032;
  };
}
