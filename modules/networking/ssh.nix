{ config, lib, pkgs, ... }:

{
  services.openssh = {
    enable = true;
    ports = [ 4684 ];
    openFirewall = false;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      AllowUsers = [ "non" ];
      KbdInteractiveAuthentication = false; # redundant
      # Logs all connection attempts
      LogLevel = "VERBOSE";

      # Replace Fail2ban with PerSourcePenalties
      # https://text.tchncs.de/senioradmin/are-you-still-banning-or-do-you-already-penalize
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
