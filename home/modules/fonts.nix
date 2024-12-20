{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    barlow
    nerd-fonts.jetbrains-mono
    # cormorant
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      emoji = [ "Noto Color Emoji" ];
      monospace = [ "JetBrainsMono Nerd Font" "Noto Sans Mono" ];
      sansSerif = [ "Barlow" "Noto Sans" ];
      serif = [ "Cormorant" "Noto Sans Serif" ];
    };
  };
}
