{ config, lib, pkgs, ... }:

{
  networking.networkmanager.enable = true;
  networking.usePredictableInterfaceNames = false;

  # networking.wireguard.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.fail2ban = {
    enable = true;
    bantime = "1m";
    bantime-increment = {
      enable = true;
      maxtime = "24h";
    };
  };

  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
