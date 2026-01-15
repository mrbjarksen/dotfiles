{ config, lib, pkgs, ... }:

{
  imports = [ ./modules ];

  networking.hostName = "neumann"; 
  system.stateVersion = "25.11";
  
  boot.initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "sd_mod" "sr_mod" ];
  boot.kernelPatches = lib.mkForce [];

  services.upower.enable = true;
  services.tlp.pd.enable = true;

  hardware.nvidia.modesetting.enable = true;
  services.xserver.videoDriver = [ "modesetting" ];

  services.fprintd.enable = true;

  nixpkgs.config.allowUnfree = true;
}
