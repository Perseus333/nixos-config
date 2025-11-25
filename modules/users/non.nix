{ config, lib, pkgs, ... }:

{
  users.users.non = {
    isNormalUser = true;
    extraGroups = [ "wheel" "samba" ];
    initialPassword = "123456";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII3F+9i74EF52Ywm+aYNxz7C/OyDkOdUD4sFeVbIgluW perseus@fedora"
    ];
  };
}
