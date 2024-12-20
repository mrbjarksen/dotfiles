{ config, lib, pkgs, ... }:

{
  imports = [ ./modules ];

  home.username = "mrbjarken";
  home.homeDirectory = "/home/mrbjarksen";
  home.stateVersion = "24.11";

  # email, calendar, contacts, passwords,
  # file manager,
  # application launcher, notifications, authentication,
  # music player (spotify),
  # keyboard things

  # services.pass-secret-service.enable = true;
}
