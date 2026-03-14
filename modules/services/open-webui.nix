{ config, lib, pkgs, ... }:

{
  services.open-webui = {
    enable = true;
    host = "127.0.0.1";
    port = 1212;
  };

  services.ollama = {
    enable = true;
    package = pkgs.ollama-vulkan;
    environmentVariables = {
      OLLAMA_VULKAN = "1";
    };
  };

  hardware.graphics = {
    enable = true;
  };

  users.users.non.extraGroups = [ "video" "render" ];
}
