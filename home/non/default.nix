{ osConfig, config, pkgs, ... }:

{
  home.stateVersion = "25.11";

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Perseus333";
        email = "perseusmith73@gmail.com";
      };
      gpg.format = "ssh";
      init.defaultBranch = "main";
      gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers";
    };
    signing = {
      key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      signByDefault = true;
    };
  };

  home.file.".ssh/allowed_signers".text = ''
    * ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILmCmYum3h6kuAsPtUva5LDCkp+fkhTzndJFoBx+Ebcx non@venti
  '';
 
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
      "venti-wg" = {
        hostname = "10.8.0.1";
        user = "non";
        identityFile = "~/.ssh/id_yubikey_3755";
        forwardAgent = true;
        port = osConfig.ports.ssh;
      };
      "xiao-wg" = {
        hostname = "10.8.0.5";
        user = "non";
        identityFile = "~/.ssh/id_yubikey_3755";
        forwardAgent = true;
        port = osConfig.ports.ssh;
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
