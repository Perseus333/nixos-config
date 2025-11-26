{ config, pkgs, lib, ... }:

{
  services.caddy = {
    enable = true;
    virtualHosts."media.perseuslynx.dev".extraConfig = ''
        reverse_proxy 10.8.0.1:8096
        tls ${config.security.acme.certs."perseuslynx.dev".directory}/cert.pem ${config.security.acme.certs."perseuslynx.dev".directory}/key.pem
    '';
    #virtualHosts."git.perseuslynx.dev".extraConfig = ''
    # reverse_proxy 127.0.0.1:3000
    #  tls ${config.security.acme.certs."perseuslynx.dev".directory}/cert.pem ${config.security.acme.certs."perseuslynx.dev".directory}/key.pem
    #'';
  };

  systemd.services.acme-perseuslynx-dev = {
    onSuccess = [ "caddy.service" ];
  };

  systemd.services.caddy-cert-reload = {
    description = "Reload Caddy when ACME certificates change";
    script = "${pkgs.systemd}/bin/systemctl reload caddy.service";
  };

  systemd.paths.caddy-cert-reload = {
    wantedBy = [ "multi-user.target" ];
    pathConfig = {
      PathChanged = config.security.acme.certs."perseuslynx.dev".directory;
    };
  };
}
