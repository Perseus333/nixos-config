{ inputs, pkgs, lib, ... }: {
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    servers.survival = {
      enable = true;
      package = pkgs.vanillaServers.vanilla; 
      jvmOpts = "-Xms8G -Xmx16G -XX:+UseG1GC";
      openFirewall = true;
      autoStart = false;
      serverProperties = {
        difficulty = 3; # hard
        gamemode = 0;
        white-list = true;
	max-players = 2;
      };
      whitelist = {
        Perseus_Lynx = "9ace5055-8f28-4fb1-96f7-b9d8867d56be";
      };
    };
  };

  nixpkgs.config.allowUnfree = true;
  networking.firewall.checkReversePath = false;
}
