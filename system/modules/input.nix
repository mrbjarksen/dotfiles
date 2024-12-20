{ config, lib, pkgs, ... }:

{
  services.libinput.enable = true;
  hardware.logitech = {
    wireless.enable = true;
    wireless.enableGraphical = true;
    lcd.enable = true;
  };
}
