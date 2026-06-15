{ config, lib, ... }:

{
  options.ivy.roles = {
    server = {
      enable = lib.mkEnableOption "home server role. Hosts services and is not exposed to the internet.";

      adblock = {
        enable = lib.mkEnableOption "SteveP blacklist (full) into Unbound's blocklist.";
      };

      cert-manager = {
        enable = lib.mkEnableOption "automated Let's Encrypt SSL certificates with acme-dns";
      };
    };

    relay = {
      enable = lib.mkEnableOption "Public relay role. Forwards traffic to the server.";
    };
  };

  config = {
    assertions = [
      {
        # Server & Relay combined are not compatible with the networking architecture
        assertion = !(config.ivy.roles.server.enable && config.ivy.roles.relay.enable);
        message = "Error: A host cannot be both a server and a relay.";
      }
    ];
  };
}
