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

    projects = "${config.home.homeDirectory}/projects";
  };

  systemd.user.tmpfiles.rules = [ "d ${config.xdg.userDirs.download} - - - 30d -" ];
}
