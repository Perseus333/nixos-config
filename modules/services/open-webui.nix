{ config, lib, pkgs, ... }:

{
  services.open-webui = {
    enable = true;
    host = "127.0.0.1";
    port = 1212;
  };

  services.ollama = {
    enable = true;
    acceleration = "rocm";
    rocmOverrideGfx = "9.0.0"; 
  };

  users.users.non.extraGroups = [ "video" "render" ];
}
