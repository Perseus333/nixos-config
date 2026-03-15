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
        "non@10.8.0.0/16"        # wireguard
      ];
      KbdInteractiveAuthentication = false; # redundant
      # Logs all connection attempts
      LogLevel = "VERBOSE";
    };
  };
  systemd.services.sshd.serviceConfig = {
    ProtectClock = lib.mkDefault true;
    ProtectHostname = lib.mkDefault true;
    RestrictRealtime = lib.mkDefault true;
    ProtectKernelTunables = lib.mkDefault true;
    ProtectKernelModules = lib.mkDefault true;
    ProtectKernelLogs = lib.mkDefault true;
    LockPersonality = lib.mkDefault true;
    SystemCallArchitectures = lib.mkDefault "native";
  };
}
