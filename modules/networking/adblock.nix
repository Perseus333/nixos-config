{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.ivy.roles.server.adblock.enable {
    services.unbound.settings.server.include = [
      "/var/lib/unbound/blocklist.conf"
    ];

    system.activationScripts.unbound-blocklist-init = {
      deps = [ "var" ];
      text = ''
        if [ ! -f /var/lib/unbound/blocklist.conf ]; then
          mkdir -p /var/lib/unbound
          touch /var/lib/unbound/blocklist.conf
        fi
      '';
    };

    systemd.services.unbound-blocklist-update = {
      description = "Update Unbound ad-blocking blocklist from StevenBlack";
      requires = [ "network-online.target" "unbound.service" ];
      after = [ "network-online.target" "unbound.service" ];
      # Block ads, malware, fake news, gambling and porn websites
      script = ''
        set -euo pipefail
        TMP=$(mktemp)

        ${pkgs.curl}/bin/curl -sSL \
          "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts" \
          -o "$TMP"

        ${pkgs.gawk}/bin/awk '
          /^0\.0\.0\.0 / && $2 != "0.0.0.0" {
            print "local-zone: \"" $2 ".\" always_nxdomain"
          }
        ' "$TMP" > /var/lib/unbound/blocklist.conf

        rm "$TMP"
        systemctl reload-or-restart unbound.service
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
    };

    systemd.timers.unbound-blocklist-update = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "2min";
        OnUnitActiveSec = "1d";
        Persistent = true;
      };
    };
  };
}
