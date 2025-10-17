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

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "suspend";
    HandlePowerKey = "suspend-then-hibernate";
    HandlePowerKeyLongPress = "suspend-then-hibernate";
  };

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "blue";
  };
}
