{ config, lib, pkgs, ... }:

{
  users.users.non = {
    isNormalUser = true;
    extraGroups = [ "wheel" "samba" "sftpgo"];
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIO0nWPCSX+E6Ze1tyHUZABf4gkfTjcxs5fXuqy6EfoYkAAAABHNzaDo= perseus@mycenae"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIPdXXZV1q964neYidTdL/fdyPuIhYzn353qe/G2BP4GvAAAABHNzaDo= perseus@mycenae"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7JN/bCd5FTaQwawqA2a0PQr1aKtkyhatL31+Oo+0ogQ5ED2vfedWySDto1zw0dfzdbHL5ooSoOdJ2WNDQ/quXeWBVeYvWLS5bOGHxoBIw6k2e7HRr/1aDNkTuQNOMVvTYYCTYoDv63u1S9sA4YO8vZrGZvsIxrbkTEFTPic1tnZqNIMxLG+wJPl3TksE4awa1FzaJkDy0qlKVa3nkjMoime91pRbbgbaeH9FKqb1Q6hzmK7On7J6KP/JqOdRt7FRMFt1mHby6ihTLAEcYDQkKi1b3xClusWLvqctTbcHg1DA/B0DdCuTKxTnnKp0QdxED7it8M4TSC53jmVE9N4kH yubikeychain-755"
    ];
  };

  users.users.root.hashedPassword = "!";
}
