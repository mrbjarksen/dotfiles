{ config, lib, pkgs, ... }:

{
  services.greetd = {
    enable = true;
    default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet";
      user = "greeter";
    };
  };
}
