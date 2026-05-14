{ config, lib, ... }:

let
  host = config.networking.hostName;
  deviceId =
    if host == "galois" then
      "nvme-Samsung_SSD_990_PRO_2TB_S6Z2NU0XA01474A"
    else if host == "neumann" then
      "nvme-Micron_2200S_NVMe_1024GB__200926C0B4C4"
    else throw "unknown host: ${host}";
in
{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/${deviceId}";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          label = "NIXOS_BOOT";
          size = "1G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        luks = {
          label = "NIXOS_LUKS";
          size = "100%";
          content = {
            type = "luks";
            name = "crypt";
            settings = {
              allowDiscards = true;
              bypassWorkqueues = true;
              # fallbackToPassword = true;
            };
            content = {
              type = "btrfs";
              extraArgs = [ "-L" "NIXOS_ROOT" "-f" ];
              subvolumes = {
                "/root" = {
                  mountpoint = "/";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
                "/log" = {
                  mountpoint = "/var/log";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
                "/home" = {
                  mountpoint = "/home";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
                "/swap" = {
                  mountpoint = "/swap";
                  swap.swapfile.size = "32G";
                };
              };
            };
          };
        };
      };
    };
  };
}
