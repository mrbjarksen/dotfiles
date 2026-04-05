{ config, lib, pkgs, ... }:

{
  xdg.enable = true;
  home.preferXdgDirectories = true;
  
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;

    desktop = "${config.home.homeDirectory}/misc/desktop";
    templates = "${config.home.homeDirectory}/misc/templates";
    publicShare = "${config.home.homeDirectory}/misc/public";
    download = "${config.home.homeDirectory}/temp";

    documents = "${config.home.homeDirectory}/media/documents";
    pictures = "${config.home.homeDirectory}/media/images";
    videos = "${config.home.homeDirectory}/media/video";
    music = "${config.home.homeDirectory}/media/audio";
  };

  # xdg.portal.extraPortals = lib.mkForce [ pkgs.xdg-desktop-portal-kde ];
  # systemd.user.services.xdg-desktop-portal-kde.after = [ "xdg-desktop-autostart.target" ];

  systemd.user.tmpfiles.rules = [ "d ${config.xdg.userDirs.download} - - - 1w -" ];
}
