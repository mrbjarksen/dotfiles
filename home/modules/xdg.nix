{ config, lib, pkgs, ... }:

{
  xdg.enable = true;
  home.preferXdgDirectories = true;

  xdg.userDirs = {
    enable = true;
    createDirectories = true;

    desktop = "${config.home.homeDirectory}/misc/desktop";
    templates = "${config.home.homeDirectory}/misc/templates";
    publicShare = "${config.home.homeDirectory}/misc/public";
    download = "${config.home.homeDirectory}/temp";

    documents = "${config.home.homeDirectory}/media/documents";
    pictures = "${config.home.homeDirectory}/media/images";
    videos = "${config.home.homeDirectory}/media/video";
    music = "${config.home.homeDirectory}/media/audio";
  };

  systemd.user.tmpfiles.rules = [ "e ${config.xdg.userDirs.download} - - - - 7d -" ];
}
