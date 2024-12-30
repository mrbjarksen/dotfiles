{ config, lib, pkgs, ... }:

{
  imports = [ ./disko.nix ];

  boot.resumeDevice = "/dev/disk/by-label/NIXOS_ROOT";
  boot.kernelParams = [ "resume_offset=533760" ];

  environment.systemPackages = with pkgs; [ btrfs-progs ];

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
  };

  zramSwap.enable = true;
  zramSwap.memoryMax = 8 * 1024 * 1024;
}
