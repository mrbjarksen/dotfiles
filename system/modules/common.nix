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

  programs.niri.enable = true;

  services.fwupd.enable = true;
  services.locate.enable = true;

  programs.firejail.enable = true;

  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "mocha";
    accent = "blue";
  };
}
