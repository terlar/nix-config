{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/nvme0n1";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "512M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        key = {
          size = "40M";
          content = {
            type = "luks";
            name = "cryptkey";
            settings.allowDiscards = true;
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/keyfile";
            };
          };
        };
        swap = {
          size = "32G";
          content = {
            type = "luks";
            name = "cryptswap";
            settings = {
              allowDiscards = true;
              keyFile = "/keyfile:/dev/mapper/cryptkey";
            };
            content = {
              type = "swap";
              discardPolicy = "both";
            };
          };
        };
        root = {
          size = "100%";
          content = {
            type = "luks";
            name = "cryptroot";
            settings = {
              allowDiscards = true;
              keyFile = "/keyfile:/dev/mapper/cryptkey";
            };
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              mountpoint = "/";
              mountOptions = [
                "compress=zstd"
                "noatime"
              ];
            };
          };
        };
      };
    };
  };
}
