{ config, lib, ... }:

let

  inherit (lib)
    mkOption
    mkDefault
    mapAttrs
    foldl'
    types
    ;

  hardeningProfiles = {
    # Main resource:
    # https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html
    # Also check out systemd.resource_control(5)

    # Base profile is always applied
    base = {
      # Prevents seeing or accessing processes from other users
      ProtectProc = "invisible";

      # Denies all extra capabilities
      CapabilityBoundingSet = "";

      # Prevents service or childs from elevating privileges through execve()
      # It may still gain privilege through IPC calls to other processes
      NoNewPrivileges = true;

      # Sets all newly created files to only be accessible by the owner user
      # To manage sharing files between services, ACLs are used per directory
      UMask = "0077";

      # Prevents the creation of core dumps, possibly containing secrets
      LimitCORE = "0";

      # Prevents modification of OS, config and mounts
      # Readonly for all system root dirs except for /dev, /proc, /sys
      # Should be used with ReadWritePaths (configure per service conf if needed)
      ProtectSystem = "strict";

      # Prevents accessing user files
      # Fully restricts access to /home, /root
      ProtectHome = true;

      # Mounts a private /tmp and /var/tmp in tmpfs (RAM)
      # Enables writing in private /tmp, /var/tmp when ProctectSystem=strict
      # If DefaultDependencies=no, it would load /var/tmp/ on disk - suboptimal
      PrivateTmp = "disconnected";

      # Restricts acess to physical devices, /dev/mem, /dev/ports
      # May break old programs trying to call mmap
      PrivateDevices = true;

      # TODO: implement netns rules
      # PrivateNetwork=false - isolation enforced through netns

      # Sets private IPC namespace - only useful for old protocols
      # Only affects System V IPC, POSIX msg queue; other sockets are unaffected 
      PrivateIPC = true;

      # Sets private PID namespace
      # Prevents proc from knowing about other procs
      PrivatePIDs = true;

      # Restricts /proc to just it's own PID
      ProcSubset = "pid";

      # Maps private namespace UIDs to random UIDs at the host
      # Even if service gets root inside namespace, 
      # it still gets mapped to random user at host
      # High security flag used by containers
      PrivateUsers = "managed";

      # Prevents reading or modifying the hostname
      ProtectHostname = true;

      # Prevents modifying the clock and time
      ProtectClock = true;
      
      # Prevents modifying kernel variables in /proc
      # They may be modified through IPC calls to other process
      # Mitigated (partially) with InaccessiblePaths
      ProtectKernelTunables = true;

      # Prevents making IPC calls to other processes that modify kernel variables
      # TODO: Research how to configure this
      # InaccessiblePaths = ""

      # Prevents loading kernel modules
      # Explain in more depth what that means
      # User operations might still automatically load modules
      # Mitigated (partially) with kernel.modules_disabled
      ProtectKernelModules = true;

      # TODO: kernel.modules_disabled, probably will need to set in a separate nix file

      # Prevents accessing the kernel logs
      ProtectKernelLogs = true;

      # Prevents accessing control groups
      # Grants only a private read-only version of /sys/fs/cgroup
      ProtectControlGroups = "strict";

      # Restrics all socket address families to logs, IP and few others
      # Does not limit systemd.sockets calls, see SystemCallFilter for that
      RestrictAddressFamilies = "AF_UNIX AF_INET";

      # Prevents accessing any namespaces at all
      RestrictNamespaces = true;

      # Hides the BFP fs
      # Prevents leaking some program information
      # TODO: Enable, currently causes breakage
      # PrivateBPF = true;

      # Locks the personality exec domain to what it was set
      # Prevents running procs as 32-bit in 64-bit for example
      LockPersonality = true;

      # Enables Write XOR Execute
      # Can be circumvented by calling executable functions
      # Causes issues with JIT, enable usesJIT profile for those services
      MemoryDenyWriteExecute = true;

      # Disables realtime scheduling
      # Useful for preventing DoS
      RestrictRealtime = true;

      # Prevents setting UID/GIDs - commonly used in LPE
      RestrictSUIDSGID = true;

      # Removes SystemV, POSIX IPC when proc is stopped
      # Those IPC objects are rarely used, safe default
      RemoveIPC = true;

      # Restrics systemd.sockets except for essential ones in system-service
      # Allowed syscalls: systemd-analyze syscall-filter @system-service  
      # Some resources like to explicitly deny other interfaces; it's useless
      # TODO: Evaluate whether @system-service offers too many privileges
      SystemCallFilter = [ "@system-service" ];

      # Returns permission error instead of killing the process
      # when trying to access a system call with no permissions
      SystemCallErrorNumber = "EPERM";

      # Prevents circumventing SystemCallFilters via other ABIs
      SystemCallArchitectures = "native";

      # Applies a mask on specified /var directories
      # All dirs not explicitly granted access which 
      # live under each of these dirs become innacessible
      /* TODO: Re-enable this once we define actual state/cache/log dirs
      TemporaryFileSystem = [ 
        "/var/lib"
        "/var/cache"
        "/var/log" 
        # "/run" TODO: Analyze how to set this right
      ];
      */

      # Restrics anyone but the service itself from acessing service files
      StateDirectoryMode = "0700";
      CacheDirectoryMode = "0700";
      LogsDirectoryMode = "0700";
      RuntimeDirectoryMode = "0700";

      # Prevents systemctl clean from stalling forever
      TimeoutCleanSec = "30s";

      # TODO: link this properly
      # Allows binding only to the specified port and protocol
      # SocketBindAllow = {ivy.ports.service.proto} + ":" + {ivy.ports.service.port}
      # SocketBindDeny = "any";

      # Disallows access to all devices except for
      # /dev/null, (u)random, zero, full
      DevicePolicy = "closed";

      # TODO: Potential future research: automating FileImage container generation
    };

    offline = {
      # Gives the server an isolated network namespace
      # Cannot communicate via IP with other procs or internet
      # Can still talk with other procs through sockets
      PrivateNetwork = true;

      # Restrics all socket system calls except for logs, and few others
      # Does not limit systemd.sockets calls, see SystemCallFilter for that
      RestrictAddressFamilies = [ "AF_UNIX" ];

      # Allows most used syscalls but explicitly restrics network
      SystemCallFilter = [ "@system-service" "~@network-io" ];
    };

    netAdmin = {
      # Allows managing network interfaces
      CapabilityBoundingSet = "CAP_NET_ADMIN";

      # Need to remove user namespace isolation or else the capabilities
      # won't apply to the host
      PrivateUsers = lib.mkForce false;
    };

    stateless = {
      # Assigns the process a random ephemeral UID/GID
      # Makes the proc fully impermanent & implies many secure features
      # Proc should never write files bc of possible UID/GID collisions
      DynamicUser = lib.mkForce true;

      # Prevents incompatibility with DynamicUser
      PrivateUsers = lib.mkForce "self";
    };

    usesNspawn = {
      # If a service is run through systemd.nspawn and /proc is masked
      # it will fail with NAMESPACE error 
      PrivatePIDs = lib.mkForce false;
    };

    unManagedUsers = {
      # For services where the config conflicts with PrivateUsers=managed
      PrivateUsers = lib.mkForce "self";
    };

    preserveGUID = {
      # When the U/GID needs to be preserved
      PrivateUsers = lib.mkForce "identity";
    };

    lowPortBinding = {
      # Allows binding to ports lower than 1024
      CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
      
      # Need to remove user namespace isolation or else the capabilities
      # won't apply to the host
      PrivateUsers = lib.mkForce false;
    };

    usesJIT = {
      # Disables Write XOR Execute
      # Would cause issues with services that rely on JIT
      MemoryDenyWriteExecute = false;
    };
  };

  availableProfiles = builtins.filter (n: n != "base") (builtins.attrNames hardeningProfiles);

  isOverride = v: builtins.isAttrs v && v ? _type && v._type == "override";

  buildServiceConfig = profileNames:
    let
      selectedNames = [ "base" ] ++ profileNames;
      selectedAttrs = map (name: hardeningProfiles.${name}) selectedNames;
      mergedAttrs = foldl' (acc: profile: acc // profile) { } selectedAttrs;
      finalAttrs = mapAttrs (k: v:
        if isOverride v then v  # keep existing priority
        else mkDefault v        # apply low default priority
      ) mergedAttrs;
    in finalAttrs;

in
{
  options.ivy.hardening = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable custom service hardening.";
    };

    services = mkOption {
      type = types.attrsOf (types.listOf (types.enum availableProfiles));
      default = { };
      description = "Attrset of service names mapped to profiles besides base";
    };
  };

  config = lib.mkIf config.ivy.hardening.enable {
    systemd.services = mapAttrs (serviceName: profiles: {
      serviceConfig = buildServiceConfig profiles;
    }) config.ivy.hardening.services;
  };
}
