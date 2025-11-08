# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.sops-nix.nixosModules.sops
    ];
  
  nix.settings.experimental-features = [ "flakes" "nix-command" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/disk/by-id";
  
  # Secret Management
  sops.defaultSopsFile = ./secrets/pandora_host.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.age.generateKey = true;

  sops.secrets."wifi-pwd" = {};

  sops.templates."secrets" = {
    content = ''
      psk=${config.sops.placeholder.wifi-pwd}
    '';
    restartUnits = [ "wpa_supplicant.service" ];
  };

  networking = {
    hostName = "pandora";
    hostId = "e281e2d1";
    # Pick only one of the below networking options.
    # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    wireless = {
      enable = true;  # Enables wireless support via wpa_supplicant.
      secretsFile = config.sops.templates."secrets".path;
      networks."SKYDRNXQ" = {
        pskRaw = "ext:psk";
      };
    };
    useDHCP = true;
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
  };

  systemd.services.wpa_supplicant = {
    after = [ "sys-subsystem-net-devices-wlp4s0.device" ];
    bindsTo = [ "sys-subsystem-net-devices-wlp4s0.device" ];
    unitConfig.RequiresMountsFor = [ "/run/secrets/rendered" ];
  };

  
  # Set your time zone.
  time.timeZone = "Europe/London";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.non = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "123456";
  };
  
  # Clears some storage
  nix.optimise.automatic = true;

  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim 
    wget
    wpa_supplicant
    networkmanager
    dhcpcd
    iproute2
    iputils
    git
    tree
    age
    sops
    home-manager
    dig
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  services.zfs = {
    autoSnapshot = {
      # Enables keeping 4 15min snapshots, 24 of 1h intervals, 7 of 1d, etc.
      enable = true;
      # --utc to prevent name conflicts
      flags = "-k -p --utc";
    };
    autoScrub = {
      enable = true;
      interval = "monthly";
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 4684 ];
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      AllowUsers = [ "non@192.168.0.0/16" ]; # local IPs
      KbdInteractiveAuthentication = false; # redundant
    };
  };

  services.fail2ban = {
    enable = true;
    ignoreIP = [ "192.168.0.0/16" ]; # local IPs
    bantime-increment.enable = true;
  };

  # Open ports in the firewall.
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 4684 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy location: /run/current-system/configuration.nix
  # Not suported with flakes
  # system.copySystemConfiguration = true;

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}

