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
      PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";
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
