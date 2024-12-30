{ config, lib, pkgs, ... }:

{
  imports = [ ./modules ];

  networking.hostName = "galois";
  system.stateVersion = "24.11";

  boot.initrd.availableKernelModules = [ "nvme" "ahci" "xhci_pci" "usb_storage" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.kernelParams = [ "nvme_core.default_ps_max_latency_us=0" "pcie_aspm=off" "pcie_port_pm=off" ];

  hardware.enableRedistributableFirmware = true;
  
  # hardware.fancontrol.enable = true;
  # services.gotify.enable = true;
  # services.{kanata,kmonad}.enable = true;

  # disko, cachix, agenix, stylix, ssh
  # encrypted networks, secure boot, mutableUsers
}
