{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    deploy-rs.url = "github:serokell/deploy-rs";

    disko = {
      url = "github:nix-community/disko/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self, 
    nixpkgs, 
    sops-nix, 
    home-manager, 
    nix-minecraft, 
    deploy-rs,
    disko,
    impermanence,
    ...
  }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.venti = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          secrets = "${self}/secrets";
        };
        modules = [
          ./hosts/venti

          # SOPS configuration
          sops-nix.nixosModules.sops
          {
            sops.defaultSopsFile = ./secrets/non.yaml;
            sops.defaultSopsFormat = "yaml";
            sops.age.keyFile = "/persist/var/lib/sops-nix/key.txt";
            sops.age.generateKey = false;
          }

          # Home Manager configuration
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.non = import ./home/non;
            home-manager.backupFileExtension = "bak";
          }

          # Minecraft configuration
          nix-minecraft.nixosModules.minecraft-servers
          {
            nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
          }

          disko.nixosModules.disko

          impermanence.nixosModules.impermanence
        ];
      };

      nixosConfigurations.xiao = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          secrets = "${self}/secrets";
        };
        modules = [
          ./hosts/xiao

          sops-nix.nixosModules.sops
          {
            sops.defaultSopsFile = ./secrets/non.yaml;
            sops.defaultSopsFormat = "yaml";
            sops.age.keyFile = "/var/lib/sops-nix/key.txt";
            sops.age.generateKey = false;
          }

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.non = import ./home/non;
            home-manager.backupFileExtension = "bak";
          }
        ];
      };
      deploy.nodes.xiao = {
        hostname = "xiao-wg";
        profiles.system = {
          user = "non";
          path = deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.xiao;
          sshUser = "non";
          sshOpts = [ "-A" ];
        };
      };

      checks = builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks self.deploy)
        deploy-rs.lib;
    };
}
