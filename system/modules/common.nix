{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    curl
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

  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    lidSwitchExternalPower = "suspend";
    powerKey = "suspend-then-hibernate";
    powerKeyLongPress = "suspend-then-hibernate";
  };
}
