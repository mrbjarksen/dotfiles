{ config, lib, pkgs, ... }:

{
  imports = [ ./modules ];

  networking.hostName = "neumann"; 
  system.stateVersion = "25.11";
  
  boot.initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "sd_mod" "sr_mod" ];
  # boot.kernelPatches = lib.mkForce [];

  services.upower.enable = true;
  services.tlp.pd.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    # powerManagement.enable = true;
    # powerManagement.finegrained = true;
  };
  # boot.extraModprobeConfig = lib.optionalString config.hardware.nvidia.powerManagement.enable ''
  #   options nvidia "NVreg_PreserveVideoMemoryAllocations=1"
  # '';

  services.fprintd =
  {
    enable = true;
    tod.enable = true;
    tod.driver = pkgs.libfprint-2-tod1-goodix;
  };

  nixpkgs.config.allowUnfree = true;
}
