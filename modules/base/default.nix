{ ... }:
{
  imports = [
    ../../modules/base/gen-docs.nix
    ../../modules/base/nix.nix
    ../../modules/base/packages.nix
    ../../modules/base/roles.nix
    ../../modules/base/security.nix
    ../../modules/base/hardening-profiles.nix
    ../../modules/base/users.nix
    ../../modules/base/zfs.nix
  ];
}
