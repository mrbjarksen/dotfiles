{ config, lib, pkgs, ... }:

{
  imports = [ ./modules ];

  networking.hostName = "neumann"; 
  system.stateVersion = "25.11";
  
  boot.initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "sd_mod" "sr_mod" ];
  boot.kernelPatches = lib.mkForce [];

  hardware.nvidia.modesetting.enable = true;

  services.fprintd.enable = true;
  services.upower.enable = true;

  nixpkgs.config.allowUnfree = true;
}
