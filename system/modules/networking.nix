{ config, lib, pkgs, ... }:

{
  networking.networkmanager.enable = true;
  networking.usePredictableInterfaceNames = false;

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

  networking.enableIPv6 = true;
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    openFirewall = true;
    settings.publish = {
      publish-domain = true;
      publish-hinfo = true;
      publish-addresses = true;
      publish-userServices = true;
      publish-workstation = true;
    };
  };
}
