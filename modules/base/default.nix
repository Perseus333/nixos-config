{ ... }:
{
  imports = [
    ../../modules/base/nix.nix
    ../../modules/base/packages.nix
    ../../modules/base/security.nix
    ../../modules/base/service-hardening.nix
    ../../modules/base/users.nix
    ../../modules/base/zfs.nix
  ];
}
