{ config, pkgs, ... }:

{
  home.stateVersion = "25.11";

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Perseus333";
        email = "perseusmith73@gmail.com";
      };
      init.defaultBranch = "main";
    };
    signing = {
      format = "openpgp";
      key = "219191D3F14A5E8F";
      signByDefault = true;
    };
  };
 
  programs.bash.bashrcExtra = ''
    rebuild-nixos() {
      local action="''${1:-switch}"
      local host="''${2:-$(hostname)}"
      local extra_args=""

      if [[ "$host" != "$(hostname)" && "$action" != "build" ]]; then
        read -p "You are targeting '$host' but you are on '$(hostname)'. Are you sure? [y/N] " confirm
        [[ $confirm == [yY] ]] || return 1
      fi

      if [ "$action" = "build" ]; then
        extra_args="--no-link"
      fi

      sudo env NIX_REMOTE=daemon nixos-rebuild "$action" --flake "/home/non/nixos#$host" $extra_args
    }

    # Define them clearly
    function test-nixos() { rebuild-nixos test "$1"; }
    function switch-nixos() { rebuild-nixos switch "$1"; }
    function build-nixos() { rebuild-nixos build "$1"; }
  '';

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "venti" = {
        hostname = "10.8.0.1";
        user = "non";
        identityFile = "~/.ssh/id_yubikey_3755";
        forwardAgent = true;
        port = 4684;
      };
      "xiao" = {
        hostname = "10.8.0.5";
        user = "non";
        identityFile = "~/.ssh/id_yubikey_3755";
        forwardAgent = true;
        port = 4684;
      };
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
