{ lib, pkgs, config, ... }:

{
  services.forgejo = {
    enable = true;
    database.type = "postgres";
    lfs.enable = true;
    settings = {
      server = {
        DOMAIN = "git.perseuslynx.dev";
        # You need to specify this to remove the port from URLs in the web UI.
        ROOT_URL = "https://git.perseuslynx.dev/"; 
        HTTP_PORT = 3000;
      };
      DEFAULT.APP_NAME = "Hefesto";
      # You can temporarily allow registration to create an admin user.
      service.DISABLE_REGISTRATION = true;
      session = {
        COOKIE_SECURE = true;
        # Sessions last for 1 week
        SESSION_LIFE_TIME = 86400 * 7;
      };
      actions = {
        ENABLED = true;
        DEFAULT_ACTIONS_URL = "https://code.forgejo.org";
      };
    };
  };
}
