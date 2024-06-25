{
  disko.devices = {
    disk.samsung-ssd = {
      type = "disk";
      device = "/dev/disk/by-id/ata-Samsung_SSD_750_EVO_500GB_S363NWAH723805V";
      content = {
        type = "gpt";
        partitions = {
          esp = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "enc";
              settings = {
                allowDiscards = true;
                bypassWorkqueues = true;
              };
              content = {
                type = "btrfs";
                subvolumes = {
                  nix = {
                    mountpoint = "/nix";
                    mountOptions = [ "noatime" "compress-force=zstd" ];
                  };

                  log = {
                    mountpoint = "/var/log";
                    mountOptions = [ "noatime" "compress=zstd" ];
                  };

                  persist = {
                    mountpoint = "/persist";
                    mountOptions = [ "noatime" "compress=zstd" ];
                  };

                  state = {
                    mountpoint = "/state";
                    mountOptions = [ "noatime" "compress=zstd" ];
                  };

                  swap = {
                    mountpoint = "/swap";
                    mountOptions = [ "noatime" "nodatacow" "nodatasum" ];
                    swap.hibernation.size = "16G";
                  };
                };
              };
            };
          };
        };
      };
    };

    nodev = {
      root = {
        fsType = "tmpfs";
        mountpoint = "/";
        mountOptions = [ "noatime" "nodev" "mode=755" "size=128M" ];
      };

      home = {
        fsType = "tmpfs";
        mountpoint = "/home";
        mountOptions = [ "noatime" "nodev" "mode=755" "size=128M" ];
      };

      tmp = {
        fsType = "tmpfs";
        mountpoint = "/tmp";
        mountOptions = [ "noatime" "nodev" "nosuid" "mode=1777" "size=90%" ];
      };
    };
  };

  boot.supportedFilesystems = [ "tmpfs" "btrfs" ];

  fileSystems = {
    "/var/log".neededForBoot = true;
    "/state".neededForBoot = true;
    "/persist".neededForBoot = true;
  };
}
