{ config, lib, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    barlow
    manrope
    nerd-fonts.jetbrains-mono
    jetbrains-mono
    cormorant
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      emoji = [ "Noto Color Emoji" ];
      monospace = [ "JetBrainsMono Nerd Font" "Noto Sans Mono" ];
      sansSerif = [ "Barlow" "Manrope" "Noto Sans" ];
      serif = [ "Cormorant" "Noto Sans Serif" ];
    };
  };
}
