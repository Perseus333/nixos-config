{ config, lib, pkgs, ... }:

{
  services.open-webui = {
    enable = true;
    host = "10.8.0.1";
    port = 1212;
    openFirewall = true;
  };

}
