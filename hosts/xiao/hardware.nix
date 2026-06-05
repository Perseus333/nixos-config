# Modified! Do not re-generate! 
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  fileSystems."/" = {
    device = "/dev/vda1";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/vda15";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 1024; # MB
    }
  ];

  zramSwap.enable = true;
}
