{ config, lib, pkgs, ... }:

{
  imports = [ ./modules ];

  networking.hostName = "galois";
  system.stateVersion = "24.11";

  boot.initrd.availableKernelModules = [ "nvme" "ahci" "xhci_pci" "usb_storage" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.kernelParams = [
    "nvme_core.default_ps_max_latency_us=0"
    "pcie_aspm=off"
    "pcie_port_pm=off"
    "amdgpu.dcdebugmask=0x10"
    "video=1920x1080"
  ];

  boot.loader.grub.gfxmodeEfi = "1920x1080,auto";
  boot.loader.grub.font = lib.mkForce "${pkgs.terminus_font}/share/fonts/terminus/ter-u12n.otb";
  console = {
    earlySetup = true;
    packages = with pkgs; [ terminus_font ];
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u12n.psf.gz";
  };

  hardware.enableRedistributableFirmware = true;

  nixpkgs.config.rocmSupport = true;

  nix.settings.trusted-users = [ "root" "builder" ];
  users.users.builder = {
    description = "Nix Remote Builder";
    isNormalUser = true;
    createHome = true;
    home = "/home/builder";
    homeMode = "500";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILRQST/op7kO83sIsmh7FdUcG5LijViTKcbPPLZkoBP/ root@neumann"
    ];
  };
  
  # hardware.fancontrol.enable = true;
  # services.gotify.enable = true;
  # services.{kanata,kmonad}.enable = true;

  # disko, cachix, agenix, stylix, ssh
  # encrypted networks, secure boot, mutableUsers
}
