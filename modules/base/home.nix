{ config, lib, pkgs, ... }:

{
  # Allow it to overwrite files (and make a backup)
  home-manager.backupFileExtension = "bak";
}
