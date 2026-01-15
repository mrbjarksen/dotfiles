{ config, lib, pkgs, ... }:

{
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
    neovim.enable = true;
    neovim.vimAlias = true;
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
}
