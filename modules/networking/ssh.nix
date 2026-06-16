{ config, lib, ... }:

{
  services.openssh = {
    enable = true;
    ports = [ config.ports.ssh ];
    openFirewall = false;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      AllowUsers = [ "non" ];
      KbdInteractiveAuthentication = false; # redundant
      # Logs all connection attempts
      LogLevel = "VERBOSE";

      # Replaced Fail2ban with PerSourcePenalties
      # https://text.tchncs.de/senioradmin/are-you-still-banning-or-do-you-already-penalize
      MaxAuthTries = 3;
      PerSourcePenalties = lib.concatStringsSep " " [
        "crash:3h" # Probably an exploit
        "invaliduser:5m"
        "authfail:5m" # If it gets this far, it's not a bot
        "max:24h"
        "overflow:deny-all" # Denies everything if logs are filled
      ];
    };
  };
  /* Disabled temporarily
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
  */
}
