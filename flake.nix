{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
  };

  

  outputs = {
    self,
    nixpkgs,
    sops-nix,
    home-manager,
    nix-minecraft,
    ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations.pandora = nixpkgs.lib.nixosSystem {
        specialArgs = { 
          inherit inputs;
          secrets = "${self}/secrets";
        };
        modules = [
          ./hosts/pandora
          
          # SOPS configuration
          sops-nix.nixosModules.sops
          {
            sops.defaultSopsFile = ./secrets/hosts/pandora.yaml;
            sops.defaultSopsFormat = "yaml";
            sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
            sops.age.generateKey = true;
          }

	  home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.non = import ./home/non;
          }

          nix-minecraft.nixosModules.minecraft-servers
          {
            nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
          }
        ];
      };
    };
  
}
