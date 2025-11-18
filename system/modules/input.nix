{ config, lib, pkgs, ... }:

{
  services.libinput.enable = true;
  hardware.logitech = {
    wireless.enable = true;
    wireless.enableGraphical = true;
    # lcd.enable = true;
  };
  services.udev.packages = [
    pkgs.dolphin-emu
    (pkgs.writeTextFile {
      name = "8bitdo-u2w-udev-rules";
      text = ''
        KERNEL=="hidraw*", ATTRS{idVendor}=="2dc8", MODE="0660", TAG+="uaccess"
        KERNEL=="hidraw*", KERNELS=="*2DC8:*", MODE="0660", TAG+="uaccess"
      '';
      destination = "/etc/udev/rules.d/71-8bitdo-u2w.rules";
    })
  ];
}
