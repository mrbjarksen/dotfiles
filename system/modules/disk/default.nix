{ config, lib, pkgs, ... }:

{
  imports = [ ./disko.nix ];

  boot.resumeDevice = "/dev/disk/by-label/NIXOS_ROOT";

  environment.systemPackages = with pkgs; [ btrfs-progs ];

  services.fstrim.enable = true;
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
  };

  zramSwap.enable = true;
  zramSwap.memoryMax = 8 * 1024 * 1024;
}
