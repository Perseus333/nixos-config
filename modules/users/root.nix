{ config, lib, pkgs, ... }:

{
  # Disables password for root
  users.users.root.hashedPassword = "!";
}
