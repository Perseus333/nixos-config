{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, sops-nix, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations.pandora = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./systems/pandora
          sops-nix.nixosModules.sops
          
          # SOPS configuration
          {
            sops.defaultSopsFile = ./secrets/hosts/pandora.yaml;
            sops.defaultSopsFormat = "yaml";
            sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
            sops.age.generateKey = true;
          }
          
          # Home Manager integration
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.root = import ./home/non;
            home-manager.users.non = import ./home/non;
          }
        ];
      };
    };
}
