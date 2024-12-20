{ config, lib, pkgs, ... }:

{
  imports = [ ./modules ];

  networking.hostName = "neumann"; 
  system.stateVersion = "24.11";
  
  boot.initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "sd_mod" "sr_mod" ];
  boot.kernelPatches = mkForce [];

  hardware.nvidia.prime = {
    offload.enable = lib.mkForce false;
    sync.enable = lib.mkForce true;
  };

  services.fprintd.enable = true;
  services.upower.enable = true;
}
