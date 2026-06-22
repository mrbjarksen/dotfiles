{ config, lib, pkgs, ... }:

{
  imports = [ ./modules ];

  home.username = "mrbjarksen";
  home.homeDirectory = "/home/mrbjarksen";
  home.stateVersion = "24.11";

  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "mocha";
    accent = "blue";
  };

  # email, calendar, contacts, passwords,
  # file manager,
  # application launcher, notifications, authentication,
  # music player (spotify),
  # keyboard things

  # services.pass-secret-service.enable = true;
}
