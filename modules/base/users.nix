{ config, lib, pkgs, ... }:

{
  users.users.non = {
    isNormalUser = true;
    extraGroups = [ "wheel" "samba" "sftpgo"];
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIO0nWPCSX+E6Ze1tyHUZABf4gkfTjcxs5fXuqy6EfoYkAAAABHNzaDo= perseus@mycenae"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIPdXXZV1q964neYidTdL/fdyPuIhYzn353qe/G2BP4GvAAAABHNzaDo= perseus@mycenae"
    ];
  };

  users.users.root.hashedPassword = "!";
}
