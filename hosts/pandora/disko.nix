{
  disko.devices = {
    disk.system = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          esp = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };

          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "panzer";
            };
          };
        };
      };
    };

    zpool.panzer = {
      type = "zpool";
      rootFsOptions = {
        # Do not specify compression algorithm
        # https://grahamc.com/blog/nixos-on-zfs
        compression = "on";
      };

      datasets = {
        root = {
          type = "zfs_fs";
          mountpoint = "/";
        };

        nix = {
          type = "zfs_fs";
          mountpoint = "/nix";
          a
        };

        home = {
          type = "zfs_fs";
          mountpoint = "/home";
        };

        media = {
          type = "zfs_fs";
          mountpoint = "/srv/media";
        };

        builds = {
          type = "zfs_fs";
          mountpoint = "/srv/builds";
        };

        swap = {
          type = "zfs_volume";
          size = "32G";
          content = {
            type = "swap";
          };
        };
      };
    };

    disk.backup = {
      type = "disk";
      device = "/dev/nvme1n1";
      content = {
        type = "filesystem";
        format = "ext4";
        mountpoint = "/mnt/backup";
      };
    };
  };
}
