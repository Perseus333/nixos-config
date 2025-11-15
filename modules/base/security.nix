{ config, lib, pkgs, ... }:

{
  # Doesn't ask for sudo password for 30 minutes
  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=30
  '';
}
