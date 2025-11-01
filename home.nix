{ config, pkgs, ... }:

{
  home.stateVersion = "25.05";

  programs.git = {
    enable = true;
    userName = "Perseus333";
    userEmail = "perseusmith73@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
  programs.bash = {
    enable = true;
  };
  programs.vim = {
    enable = true;
  };
  home.sessionVariables = {
    EDITOR = "vim";
  };
}
