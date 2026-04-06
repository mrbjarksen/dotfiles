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

  nixpkgs.config.cudaSupport = true;
  nix.settings.substituters = [ "https://cache.nixos-cuda.org" ];
  nix.settings.trusted-public-keys = [ "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" ];

  services.fprintd = {
    enable = true;
    tod.enable = true;
    tod.driver = pkgs.libfprint-2-tod1-goodix;
  };

  nixpkgs.config.allowUnfree = true;

  nix.buildMachines = [{
    hostName = "galois-builder";
    system = "x86_64-linux";
    protocol = "ssh-ng";
    maxJobs = 4;
    speedFactor = 2;
    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
  }];
  nix.distributedBuilds = true;
  nix.settings.builders-use-substitutes = true;
}
