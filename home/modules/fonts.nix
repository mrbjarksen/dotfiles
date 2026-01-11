{ config, lib, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    # Mix
    lmodern
    fira

    # Monospace
    nerd-fonts.jetbrains-mono
    jetbrains-mono
    nerd-fonts.fira-code
    fira-code

    # Sans Serif
    barlow
    inter
    lato
    libre-franklin
    # manrope
    merriweather-sans
    montserrat

    # Serif
    bodoni-moda
    cardo
    cormorant
    crimson
    eb-garamond
    edwin
    fraunces
    # junge
    libre-baskerville
    # maitree
    merriweather
    # playfair-display
    sorts-mill-goudy
    # wittgenstein
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      emoji = [ "Noto Color Emoji" ];
      monospace = [ "JetBrainsMono Nerd Font" "Noto Sans Mono" ];
      sansSerif = [ "Lato" "Noto Sans" ];
      serif = [ "Crimson" "Noto Serif" ];
    };
  };
}
