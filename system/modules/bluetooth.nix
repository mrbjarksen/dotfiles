{ config, lib, pkgs, ... }:

{
  hardware.bluetooth = {
    enable = true;
    hsphfpd.enable = true;
    settings.General = {
      Class = lib.attrsets.attrByPath [ config.networking.hostName ] "0x000000" {
        neumann = "0x00010c"; # Laptop
        galois = "0x000104"; # Desktop
      };
      FastConnectable = true;
      JustWorksRepairing = "always";
    };
  };
}
