{ config, lib, ... }:

let

  profiles = {

    strict = {
      NoNewPrivileges          = true;
      PrivateTmp               = true;
      PrivateDevices           = true;
      ProtectSystem            = "strict";
      ProtectHome              = true;
      ProtectKernelTunables    = true;
      ProtectKernelModules     = true;
      ProtectKernelLogs        = true;
      ProtectControlGroups     = true;
      ProtectHostname          = true;
      ProtectClock             = true;
      RestrictSUIDSGID         = true;
      LockPersonality          = true;
      RestrictNamespaces       = true;
      RestrictRealtime         = true;
      MemoryDenyWriteExecute   = true;
      ProtectProc              = "invisible";
      ProcSubset               = "pid";
      CapabilityBoundingSet    = "";
      SystemCallArchitectures  = "native";
      SystemCallFilter         = [ "@system-service" "~@privileged" "~@resources" ];
      UMask                    = "0077";
    };

    network = {
      NoNewPrivileges          = true;
      PrivateTmp               = true;
      PrivateDevices           = true;
      ProtectSystem            = "strict";
      ProtectHome              = true;
      ProtectKernelTunables    = true;
      ProtectKernelModules     = true;
      ProtectKernelLogs        = true;
      ProtectControlGroups     = true;
      ProtectHostname          = true;
      ProtectClock             = true;
      RestrictSUIDSGID         = true;
      LockPersonality          = true;
      RestrictNamespaces       = true;
      ProtectProc              = "invisible";
      ProcSubset               = "pid";
      CapabilityBoundingSet    = "";
      RestrictRealtime         = true;
      SystemCallArchitectures  = "native";
      SystemCallFilter         = [ "@system-service" "@network-io" "~@privileged" ];
      UMask                    = "0077";
    };

  };

  mkProfile = profile:
    lib.mapAttrs (_: lib.mkDefault) profile;

in {

  options.harden = {
    strict = lib.mkOption {
      type    = lib.types.listOf lib.types.str;
      default = [];
      description = "Services to apply the strict hardening profile to.";
    };
    network = lib.mkOption {
      type    = lib.types.listOf lib.types.str;
      default = [];
      description = "Services to apply the network hardening profile to.";
    };
  };

  config.systemd.services =
    lib.mergeAttrsList [
      (lib.genAttrs config.harden.strict   (_: { serviceConfig = mkProfile profiles.strict;   }))
      (lib.genAttrs config.harden.network  (_: { serviceConfig = mkProfile profiles.network;  }))
    ];

}
