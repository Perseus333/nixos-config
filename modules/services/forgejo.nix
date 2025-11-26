{ lib, pkgs, config, ... }:

{
  services.forgejo = {
    enable = true;
    database.type = "postgres";
    # Enable support for Git Large File Storage
    lfs.enable = true;
    settings = {
      server = {
        DOMAIN = "git.perseuslynx.dev";
        # You need to specify this to remove the port from URLs in the web UI.
        ROOT_URL = "https://git.perseuslynx.dev/"; 
        HTTP_PORT = 3000;
      };
      # You can temporarily allow registration to create an admin user.
      service.DISABLE_REGISTRATION = true; 
      # Add support for actions, based on act: https://github.com/nektos/act
      # actions = {
      #   ENABLED = true;
      #   DEFAULT_ACTIONS_URL = "github";
    };
  };
}
