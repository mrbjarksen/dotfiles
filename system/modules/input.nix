{ config, lib, pkgs, ... }:

{
  services.libinput.enable = true;
  hardware.logitech = {
    enable = true;
    enableGraphical = true;
    lcd.enable = true;
  };
}
