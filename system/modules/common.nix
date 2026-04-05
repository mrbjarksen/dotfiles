{ config, lib, pkgs, ... }:

{
  # TODO Lenovo Qreator not detected with brightnessctl; works with ddcutil (some issue with permissions?)
  hardware.i2c.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    curl
    gcc
    unzip
  ];

  programs = {
    htop.enable = true;
    git.enable = true;
    less.enable = true;
    nano.enable = true;
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };
  };

  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [ noto-fonts noto-fonts-color-emoji ];

  services.fwupd.enable = true;
  services.locate.enable = true;

  programs.firejail.enable = true;

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "blue";
  };

  # Fix services starting before niri-session
  # TODO This doesn't work i think
  systemd.user.services.xdg-desktop-portal = { after = [ "xdg-desktop-autostart.target" ]; };
  systemd.user.services.xdg-desktop-portal-gtk = { after = [ "xdg-desktop-autostart.target" ]; };
  systemd.user.services.xdg-desktop-portal-gnome = { after = [ "xdg-desktop-autostart.target" ]; };
  systemd.user.services.niri-flake-polkit = { after = [ "xdg-desktop-autostart.target" ]; };
}
