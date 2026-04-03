{ config, lib, pkgs, ... }:

{
  sops.secrets.non-pwd-hash = {
    neededForUsers = true;
  };
  users.users.non = {
    isNormalUser = true;
    extraGroups = [ "wheel" "samba" "sftpgo"];
    hashedPasswordFile = config.sops.secrets.non-pwd-hash.path;
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIO0nWPCSX+E6Ze1tyHUZABf4gkfTjcxs5fXuqy6EfoYkAAAABHNzaDo= perseus@mycenae"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIPdXXZV1q964neYidTdL/fdyPuIhYzn353qe/G2BP4GvAAAABHNzaDo= perseus@mycenae"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7JN/bCd5FTaQwawqA2a0PQr1aKtkyhatL31+Oo+0ogQ5ED2vfedWySDto1zw0dfzdbHL5ooSoOdJ2WNDQ/quXeWBVeYvWLS5bOGHxoBIw6k2e7HRr/1aDNkTuQNOMVvTYYCTYoDv63u1S9sA4YO8vZrGZvsIxrbkTEFTPic1tnZqNIMxLG+wJPl3TksE4awa1FzaJkDy0qlKVa3nkjMoime91pRbbgbaeH9FKqb1Q6hzmK7On7J6KP/JqOdRt7FRMFt1mHby6ihTLAEcYDQkKi1b3xClusWLvqctTbcHg1DA/B0DdCuTKxTnnKp0QdxED7it8M4TSC53jmVE9N4kH yubikeychain-755"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDBOqk8KY/daYT/D3RgYxb+iKGeXnHHZnC5ZAn97yFI5b6knnPoTS40fJJJK9p8gDw0xVTHpgDZY/WbYdZRme6qGxItmp0k2Ww9jq/uig+JeX6dwMvdhKYwF8jncQqf9UqqJwcNDJmnzROTlzjDjX0B4Ol8swmkqqbcE2jStALReqzmre6nXhTFepIlSOR8HGNXEvZ9nf8YgFQhG0j6Cyu6UWbpeN018TQMtw59/8ZC//APH0gOjNFPrcJNStwj019qI8GpcBa+eipIxsMPIy3w5snTIv8ODlbx3mjI5kc3bgzzPgov12spP8PZjKOQGBxJRvn6joYsGh7EAAQZlS4Ub0AfiB3masicw3kG3dv7vfj91UzP5+0SaA1seKJ0UW2Nwv3a3sx3dDjY7TKWBz7sbbxARKexdz81aerrJhwsPnlsj3FmnMGfjeG+dylmnfHq9588CobXgrU4EPhcgPdmyI3qZotREGErnysQTtAgy/H02t3hl3rULyD9QJge0wu683efIcq6WJHFCwjYYHokC3RXubJIle0LywNuMlz2bKYm2qM8qj9qHDEff8OCAlb9IvQ40uGCAaH1xG07GSI7u6NL0Pzt7D/r2Gx08EHuV07gIR86YrYk364TXiVl3nohogNTT387HmzfgO01DvYhHx3YujIStqwoOxjU9Y5Vsw== yubikeychain-022"
    ];
  };

  users.users.root.hashedPassword = "!";
}
