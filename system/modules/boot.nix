{ config, lib, pkgs, ... }:

{
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 10;

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    fsIdentifier = "label";
    configurationLimit = 10;
    # ... theming ...
  };

  boot.plymouth = {
    enable = true;
    # ... theming ...
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
}
