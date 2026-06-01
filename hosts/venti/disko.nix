{
  disko.devices = {

    disk.system = {
      type   = "disk";
      device = "/dev/disk/by-id/nvme-CT1000P3PSSD8_25154F4155D1";
      content = {
        type = "gpt";
        partitions = {

          esp = {
            size    = "1G";
            type    = "EF00";
            content = {
              type         = "filesystem";
              format       = "vfat";
              mountpoint   = "/boot";
              mountOptions = [ "fmask=0077" "dmask=0077" ];
            };
          };

          luks-system = {
            size    = "100%";
            content = {
              type   = "luks";
              name   = "cryptsystem";

              extraFormatArgs = [
                "--type"   "luks2"
                "--pbkdf"  "argon2id"
                "--label"  "cryptsystem"
              ];

              settings = {
                allowDiscards    = true;
                bypassWorkqueues = true;
              };

              content = {
                type = "zfs";
                pool = "rpool";
              };
            };
          };
        };
      };
    };

    zpool.rpool = {
      type = "zpool";

      options = {
        ashift    = "12";
        autotrim  = "on";
      };

      # TODO: explain options
      rootFsOptions = {
        compression             = "on";
        acltype                 = "posixacl";
        xattr                   = "sa";
        dnodesize               = "auto";
        atime                   = "off";
        mountpoint              = "none";
        canmount                = "off";
        "com.sun:auto-snapshot" = "false";
      };

      datasets = {

        # Ephemeral data
        "local" = {
          type    = "zfs_fs";
          options = { mountpoint = "none"; canmount = "off"; };
        };

        "local/root" = {
          mountpoint = "/";
          type       = "zfs_fs";
          options = { "com.sun:auto-snapshot" = "false"; };
          # Creates a snapshot of / when it is empty to roll back to
          postCreateHook = "zfs snapshot rpool/local/root@blank";
        };

        "local/nix" = {
          mountpoint = "/nix";
          type       = "zfs_fs";
          options = { "com.sun:auto-snapshot" = "false"; };
        };

        "local/swap" = {
          type    = "zfs_volume";
          size    = "32G";
          content = {
            type          = "swap";
            discardPolicy = "both";
          };
          # TODO: explain options
          options = {
            volblocksize            = "4096";
            compression             = "zle";
            primarycache            = "metadata";
            secondarycache          = "none";
            "com.sun:auto-snapshot" = "false";
          };
        };

        # Data to persist
        "safe" = {
          type    = "zfs_fs";
          options = { mountpoint = "none"; canmount = "off"; };
        };

        # Misc data that matters
        "safe/persist" = {
          type       = "zfs_fs";
          mountpoint = "/persist";
          options = { "com.sun:auto-snapshot" = "true"; };
        };

        "safe/home" = {
          mountpoint = "/home";
          type       = "zfs_fs";
          options = { "com.sun:auto-snapshot" = "true"; };
        };

        # Includes data and media
        "safe/srv" = {
          mountpoint = "/srv";
          type       = "zfs_fs";
          # Can't afford snapshots due to large size
          options = { "com.sun:auto-snapshot" = "false"; };
        };
      };
    };

    # --------------------------------
    # BACKUP DISK (imperative for now)

    # disk.backup = {
    #   type   = "disk";
    #   device = "/dev/disk/by-id/nvme-WD_BLACK_SN7100_2TB_25483Q809400";
    #   content = {
    #     type = "gpt";
    #     partitions = {
    #       luks-backup = {
    #         size    = "100%";
    #         content = {
    #           type   = "luks";
    #           name   = "cryptbackup";
    #
    #           extraFormatArgs = [
    #             "--type"  "luks2"
    #             "--pbkdf" "argon2id"
    #             "--label" "cryptbackup"
    #           ];
    #
    #           settings.allowDiscards = true;
    #
    #           content = {
    #             type = "zfs";
    #             pool = "bpool";
    #           };
    #         };
    #       };
    #     };
    #   };
    # };

    # zpool.bpool = {
    #   type = "zpool";
    #
    #   options = {
    #     ashift   = "12";
    #     autotrim = "on";
    #   };
    #
    #   rootFsOptions = {
    #     compression             = "zstd";
    #     atime                   = "off";
    #     mountpoint              = "none";
    #     canmount                = "off";
    #     "com.sun:auto-snapshot" = "false";
    #   };
    #
    #   datasets = {
    #     "restic" = {
    #       type       = "zfs_fs";
    #       mountpoint = "/mnt/backup/restic";
    #       options    = {
    #         "com.sun:auto-snapshot" = "true";
    #       };
    #     };
    #
    #     "snapshots" = {
    #       type    = "zfs_fs";
    #       options = { mountpoint = "none"; canmount = "off"; };
    #     };
    #
    #     "snapshots/media" = {
    #       type       = "zfs_fs";
    #       mountpoint = "/mnt/backup/snapshots/media";
    #       options    = {
    #         "com.sun:auto-snapshot" = "false";
    #       };
    #     };
    #
    #     "snapshots/persist" = {
    #       type       = "zfs_fs";
    #       mountpoint = "/mnt/backup/snapshots/persist";
    #       options    = {
    #         "com.sun:auto-snapshot" = "false";
    #       };
    #     };
    #   };
    # };
  };
}
