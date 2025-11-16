{ config, pkgs, lib, ... }:

{
  sops.secrets.inadyn-config = {
    format = "binary";
    sopsFile = ../../secrets/services/inadyn.conf;
    owner = "inadyn";
    mode = "0400";
  };

  users.users.inadyn = {
    isSystemUser = true;
    group = "inadyn";
  };

  users.groups.inadyn = {};

  services.inadyn = {
    enable = true;
    configFile = config.sops.secrets.inadyn-config.path;
  };
}
