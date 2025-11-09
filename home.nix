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
  home.shellAliases = {
    test-nixos = "sudo nixos-rebuild test --flake /home/non/nixos#pandora";
    switch-nixos = "sudo nixos-rebuild switch --flake /home/non/nixos#pandora";
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
