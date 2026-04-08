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

    disk.backup = {
      type   = "disk";
      device = "/dev/disk/by-id/nvme-WD_BLACK_SN7100_2TB_25483Q809400";
      content = {
        type = "gpt";
        partitions = {
          luks-backup = {
            size    = "100%";
            content = {
              type   = "luks";
              name   = "cryptbackup";

              extraFormatArgs = [
                "--type"  "luks2"
                "--pbkdf" "argon2id"
                "--label" "cryptbackup"
              ];

              settings.allowDiscards = true;

              content = {
                type = "zfs";
                pool = "bpool";
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

        "local" = {
          type    = "zfs_fs";
          options = { mountpoint = "none"; canmount = "off"; };
        };

        "local/root" = {
          type       = "zfs_fs";
          mountpoint = "/";
          options    = {
            "com.sun:auto-snapshot" = "false";
          };
          postCreateHook = "zfs snapshot rpool/local/root@blank";
        };

        "local/nix" = {
          type       = "zfs_fs";
          mountpoint = "/nix";
          options    = {
            "com.sun:auto-snapshot" = "false";
          };
        };

        "local/swap" = {
          type    = "zfs_volume";
          size    = "32G";
          content = {
            type          = "swap";
            discardPolicy = "both";
          };
          options = {
            volblocksize            = "4096";
            compression             = "zle";
            primarycache            = "metadata";
            secondarycache          = "none";
            "com.sun:auto-snapshot" = "false";
          };
        };


        "safe" = {
          type    = "zfs_fs";
          options = { mountpoint = "none"; canmount = "off"; };
        };

        "safe/persist" = {
          type       = "zfs_fs";
          mountpoint = "/persist";
          options    = {
            "com.sun:auto-snapshot" = "true";
          };
        };

        "safe/home" = {
          type       = "zfs_fs";
          mountpoint = "/home";
          options    = {
            "com.sun:auto-snapshot" = "true";
          };
        };

        "safe/media" = {
          type       = "zfs_fs";
          mountpoint = "/srv/media";
          options    = {
            "com.sun:auto-snapshot" = "false";
          };
        };

        "safe/data" = {
          type       = "zfs_fs";
          mountpoint = "/srv/data";
          options    = {
            "com.sun:auto-snapshot" = "true";
          };
        };
      };
    };

    zpool.bpool = {
      type = "zpool";

      options = {
        ashift   = "12";
        autotrim = "on";
      };

      rootFsOptions = {
        compression             = "zstd";
        atime                   = "off";
        mountpoint              = "none";
        canmount                = "off";
        "com.sun:auto-snapshot" = "false";
      };

      datasets = {
        "restic" = {
          type       = "zfs_fs";
          mountpoint = "/mnt/backup/restic";
          options    = {
            "com.sun:auto-snapshot" = "true";
          };
        };

        "snapshots" = {
          type    = "zfs_fs";
          options = { mountpoint = "none"; canmount = "off"; };
        };

        "snapshots/media" = {
          type       = "zfs_fs";
          mountpoint = "/mnt/backup/snapshots/media";
          options    = {
            "com.sun:auto-snapshot" = "false";
          };
        };

        "snapshots/persist" = {
          type       = "zfs_fs";
          mountpoint = "/mnt/backup/snapshots/persist";
          options    = {
            "com.sun:auto-snapshot" = "false";
          };
        };
      };
    };
  };
}
