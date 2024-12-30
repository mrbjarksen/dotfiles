{ config, lib, pkgs, ... }:

{
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-user-session --user-menu --asterisks";
      user = "greeter";
    };
  };
}
