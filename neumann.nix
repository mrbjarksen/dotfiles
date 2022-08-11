{ config, pkgs, ... }:

{
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  boot.initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "sd_mod" "sr_mod" ];

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      fsIdentifier = "label";
      configurationLimit = 10;
    };
  };

  networking.networkmanager.enable = true;
  
  time.timeZone = "Atlantic/Reykjavik";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME           = "en_GB.UFT-8";
    LC_COLLATE        = "is_IS.UFT-8";
    LC_MONETARY       = "is_IS.UFT-8";
    LC_PAPER          = "is_IS.UFT-8";
    LC_NAME           = "is_IS.UFT-8";
    LC_ADDRESS        = "is_IS.UFT-8";
    LC_TELEPHONE      = "is_IS.UFT-8";
    LC_MEASUREMENT    = "is_IS.UFT-8";
    LC_IDENTIFICATION = "is_IS.UFT-8";
  };

  services.xserver = {
    layout = "us,is";
    xkbOptions = "grp:caps_toggle";
  };

  services.xserver = {
    enable = true;
    resolutions = [
      { x = 3840; y = 2400; } # 4k   16:10
      { x = 2560; y = 1600; } # 2.5k 16:10
      { x = 1920; y = 1200; } # 2k   16:10
    ];
    windowManager.xmonad.enable = true;
  };

  services.xserver.displayManager.lightdm = {
    enable = true;
  };

  services.xserver.libinput.enable = true;

  sound = {
    enable = true;
    mediaKeys = {
      enable = true;
      volumeStep = "5%";
    };
  };
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  hardware.bluetooth = {
    enable = true;
    hsphfpd.enable = true;
  };

  zramSwap.enable = true;

  users.users.mrbjarksen = {
    description = "Bjarki Baldursson Harksen";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "password";
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  environment.pathsToLink = [ "/share/zsh" ];
}
