{ config, lib, pkgs, ... }:

{
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    usershares.enable = true;
    shares.media = {
      path = "/srv/media";
      browseable = "yes";
      writable = "yes";
      "valid users" = "non";
    };
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "pandorasmb";
        "netbios name" = "pandorasmb";
        "security" = "user";
        "hosts allow" = "10.8.0.";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
      "media" = {
        "path" = "/srv/media";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "force user" = "non";
        "force group" = "samba";
      };
    };
  };

}

