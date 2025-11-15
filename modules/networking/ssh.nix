{ config, lib, pkgs, ... }:

{
  services.openssh = {
    enable = true;
    ports = [ 4684 ];
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      AllowUsers = [
        "non@192.168.0.0/16"     # local IPv4
        "non@fd7b:323:3ba9::/48" # local IPv6
      ];
      KbdInteractiveAuthentication = false; # redundant
      # Logs all connection attempts
      LogLevel = "VERBOSE";
    };
  };
}
