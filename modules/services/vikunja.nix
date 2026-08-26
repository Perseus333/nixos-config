{ config, pkgs, ... }:

{
  services.vikunja = {
    enable = true;
    port = config.ports.vikunja;
    frontendScheme = "https";
    frontendHostname = "todo.perseuslynx.dev";
 };
}
