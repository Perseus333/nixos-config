{
  disko.devices = {
    disk.main = {
      type   = "disk";
      device = "/dev/vda";
      content = {
        type = "gpt";
        partitions = {

          bios = {
            size = "1M";
            type = "EF02";
          };

          # Just in case I switch VPS providers and they use UEFI
          esp = {
            size    = "512M";
            type    = "EF00";
            content = {
              type       = "filesystem";
              format     = "vfat";
              mountpoint = "/boot";
            };
          };

          swap = {
            size    = "2G";
            content = { type = "swap"; };
          };

          root = {
            size    = "100%";
            content = {
              type      = "btrfs";
              extraArgs = [ "-L" "nixos" "--force" ];

              subvolumes = {

                "@root" = {
                  mountpoint   = "/";
                  mountOptions = [ "compress=zstd:1" "noatime" ];
                };

                "@root-blank" = { };

                "@nix" = {
                  mountpoint   = "/nix";
                  mountOptions = [ "compress=zstd:1" "noatime" ];
                };

                "@persist" = {
                  mountpoint   = "/persist";
                  mountOptions = [ "compress=zstd:1" "noatime" ];
                };

                "@log" = {
                  mountpoint   = "/var/log";
                  mountOptions = [ "compress=zstd:1" "noatime" ];
                };
              };
            };
          };
        };
      };
    };
  };
}
