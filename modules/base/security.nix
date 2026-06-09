{ config, lib, pkgs, ... }:

{
  # Doesn't ask for sudo password for 5 minutes
  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=5
  '';

  # Enables GPG for signing commits
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
  };
}
