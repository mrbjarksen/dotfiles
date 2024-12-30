{ config, lib, pkgs, ... }:

{
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LANG = "en_US.UTF-8";
    LC_TIME = "en_DK.UTF-8";
    LC_COLLATE = "is_IS.UTF-8";
    LC_MONETARY = "is_IS.UTF-8";
    LC_PAPER = "is_IS.UTF-8";
    LC_TELEPHONE = "is_IS.UTF-8";
    LC_MEASUREMENT = "is_IS.UTF-8";
  };

  services.automatic-timezoned.enable = true;
  services.geoclue2.enable = true;
  location.provider = "geoclue2";
}
