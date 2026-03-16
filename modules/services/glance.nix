# modules/services/glance.nix
{ config, lib, pkgs, ... }:

let
  cssFile = pkgs.writeText "glance-custom.css" ''
    .widget-type-monitor .list-horizontal-text {
      display: none !important;
    }
  '';
in
{
  services.glance = {
    enable = true;
    settings = {

      server.port = 5678;
      theme = {
        background-color = "206 13.5 20.4";
        primary-color = "41 31.8 74.7";
        positive-color = "83 33.7 62.7";
        negative-color = "359 67.5 69.8";
        contrast-multiplier = 3;
        disable-picker = true;
        custom-css-file = "${cssFile}";
      };

      branding.hide-footer = true;

      pages = [
        {
          name = "Home";
          width = "slim";
          center-vertically = true;
          columns = [
            {
              size = "full";
              widgets = [
                {
                  type = "html";
                  source = ''
                    <pre
                    style="
                    text-align: center;
                    font-size: 9px;
                    margin-bottom: 5em;
                    "
                    >
                    /$$$$$$$                      /$$       /$$                                           /$$
                    | $$__  $$                    | $$      | $$                                          | $$
                    | $$  \ $$  /$$$$$$   /$$$$$$$| $$$$$$$ | $$$$$$$   /$$$$$$   /$$$$$$   /$$$$$$   /$$$$$$$
                    | $$  | $$ |____  $$ /$$_____/| $$__  $$| $$__  $$ /$$__  $$ |____  $$ /$$__  $$ /$$__  $$
                    | $$  | $$  /$$$$$$$|  $$$$$$ | $$  \ $$| $$  \ $$| $$  \ $$  /$$$$$$$| $$  \__/| $$  | $$
                    | $$  | $$ /$$__  $$ \____  $$| $$  | $$| $$  | $$| $$  | $$ /$$__  $$| $$      | $$  | $$
                    | $$$$$$$/|  $$$$$$$ /$$$$$$$/| $$  | $$| $$$$$$$/|  $$$$$$/|  $$$$$$$| $$      |  $$$$$$$
                    |_______/  \_______/|_______/ |__/  |__/|_______/  \______/  \_______/|__/       \_______/
                    </pre>
                  '';
                }
                {
                  type = "monitor";
                  cache = "1m";
                  hide-header = true;
                  sites = [
                    { title = "Vaultwarden"; url = "https://vault.perseuslynx.dev/";        icon = "si:vaultwarden"; }
                    { title = "Radicale";    url = "https://cal.perseuslynx.dev/.web/";     icon = "sh:radicale-light"; }
                    { title = "Syncthing";   url = "https://sync.perseuslynx.dev/";         icon = "si:syncthing"; }
                    { title = "Backrest";    url = "https://bak.perseuslynx.dev/";          icon = "sh:backrest-light"; alt-status-codes = [ 200 302 401 ];}
                    { title = "Open WebUI";  url = "https://ai.perseuslynx.dev/";           icon = "sh:open-webui-light"; alt-status-codes = [ 200 302 401 ];}
                    { title = "SFTPGo";      url = "https://files.perseuslynx.dev/";        icon = "sh:sftpgo-light"; }
                    { title = "Jellyfin";    url = "https://media.perseuslynx.dev/";        icon = "sh:jellyfin-light"; }
                    { title = "Forgejo";     url = "https://git.perseuslynx.dev/";          icon = "sh:forgejo-light"; }
                    { title = "SearXNG";     url = "https://search.perseuslynx.dev/";       icon = "sh:searxng-light"; }
                    { title = "Glance";      url = "https://home.perseuslynx.dev/";         icon = "sh:glance-light"; }
                    { title = "Authelia";    url = "https://auth.perseuslynx.dev/";         icon = "sh:authelia-light"; }
                    { title = "NGINX";       url = "https://perseuslynx.dev/";              icon = "sh:nginx-light"; }
                    #{ title = "Pi-hole";     url = "https://pihole.perseuslynx.dev/admin/"; icon = "si:pi-hole"; }
                    #{ title = "Calibre";     url = "https://books.perseuslynx.dev/";        icon = "sh:calibre-web-light"; }
                  ];
                }
              ];
            }
          ];
        }

        {
          name = "Feed";
          width = "wide";
          columns = [
            {
              size = "full";
              widgets = [
                {
                  type = "split-column";
                  max-columns = 5;
                  widgets = [
                    { type = "hacker-news"; }
                    { type = "reddit"; subreddit = "philosophy"; }
                    { type = "reddit"; subreddit = "AskPhilosophy"; }
                    { type = "reddit"; subreddit = "slatestar-codex"; }
                    { type = "reddit"; subreddit = "AskEconomics"; }
                    { type = "reddit"; subreddit = "selfhosted"; }
                    { type = "reddit"; subreddit = "Linux"; }
                    { type = "reddit"; subreddit = "ErgoMechKeyboards"; }
                  ];
                }
              ];
            }
          ];
        }
      ];
    };
  };
}
