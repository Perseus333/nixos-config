{ config, pkgs, ... }:

{
  home.stateVersion = "25.05";

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Perseus333";
        email = "perseusmith73@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };
  
  home.shellAliases = {
    test-nixos = "sudo env NIX_REMOTE=daemon nixos-rebuild test --flake /home/non/nixos#pandora";
    switch-nixos = "sudo env NIX_REMOTE=daemon nixos-rebuild switch --flake /home/non/nixos#pandora";
    build-nixos = "sudo env NIX_REMOTE=daemon nixos-rebuild build --flake /home/non/nixos#pandora";
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
