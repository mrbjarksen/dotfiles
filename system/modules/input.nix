{ config, lib, pkgs, ... }:

{
  services.libinput.enable = true;
  hardware.logitech = {
    wireless.enable = true;
    wireless.enableGraphical = true;
    # lcd.enable = true;
  };
  services.udev.packages = [ pkgs.dolphin-emu ];
  services.udev.extraRules = ''
    SUBSYSTEM=="INPUT", ATTRS{idVendor}=="2dc8", ATTRS{idProduct}=="310b", MODE="0660" GROUP="INPUT"
  '';
}
