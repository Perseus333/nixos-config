{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    
    sops-nix = {
      url = "github:Mic92/sops-nix";
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
          ./hosts/pandora
          sops-nix.nixosModules.sops
          
          # SOPS configuration
          {
            sops.defaultSopsFile = ./secrets/hosts/pandora.yaml;
            sops.defaultSopsFormat = "yaml";
            sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
            sops.age.generateKey = true;
          }
        ];
      };
    };
  }
}
