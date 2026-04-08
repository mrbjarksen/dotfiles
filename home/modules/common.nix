{ config, lib, pkgs, ... }:

{
  programs.home-manager.enable = true;
  manual.json.enable = true;

  home.packages = with pkgs; [
    nixd
    bscpylgtv
    nautilus
  ];

  gtk.enable = true;
  gtk.gtk4.theme = config.gtk.theme;

  qt.enable = true;
  qt.style.name = "kvantum";
  qt.platformTheme.name = "kvantum";

  # home.language = {
  #   base = "en_US.UTF-8";
  #
  #   time        = "en_DK.UTF-8";
  #   collate     = "is_IS.UTF-8";
  #   monetary    = "is_IS.UTF-8";
  #   paper       = "is_IS.UTF-8";
  #   telephone   = "is_IS-UTF-8";
  #   measurement = "is_IS.UTF-8";
  #
  #   ctype    = "en_US.UTF-8";
  #   messages = "en_US.UTF-8";
  #   address  = "en_US.UTF-8";
  #   name     = "en_US.UTF-8";
  # };

  programs.firefox.enable = true; # <-
  programs.imv.enable = true; # <-
  programs.mpv.enable = true; # <-

  services.playerctld.enable = true;
  services.mpris-proxy.enable = true;

  programs.fzf.enable = true;
  programs.ripgrep.enable = true;
  programs.fd.enable = true;

  # services.wpaperd = {
  #   enable = true;
  #   settings = let
  #     wallpapers = "${config.xdg.userDirs.pictures}/wallpapers";
  #   in {
  #     default.mode = "center";
  #     "eDP-1".path = "${wallpapers}/puddles-3800-2360.png";
  #     "DP-1".path = "${wallpapers}/puddles-3840-2160.png";
  #     "HDMI-A-2".path = "${wallpapers}/puddles-3840-2160.png";
  #   };
  # };

  services.dunst.enable = true;

  services.cliphist.enable = true;

  programs.aria2 = {
    enable = true;
    settings = {
      dir = config.xdg.userDirs.download;
    };
  };
}
