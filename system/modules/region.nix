{ config, lib, pkgs, ... }:

{
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings.LC_TIME = "is_IS.UTF-8";

  services.automatic-timezoned.enable = true;
  services.geoclue2.enable = true;
  location.provider = "geoclue2";
}
