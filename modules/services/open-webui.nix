{ config, lib, pkgs, ... }:

{
  services.open-webui = {
    enable = true;
    host = "127.0.0.1";
    port = config.ports.open-webui;
    environment = {
      RAG_WEB_SEARCH_ENGINE = "searxng";
      SEARXNG_QUERY_URL = "http://127.0.0.1:8888/search?q=<query>"; 
      ENABLE_RAG_LOCAL_WEB_FETCH = "True"; 
    };
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
