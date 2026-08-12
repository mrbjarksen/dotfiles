{ config, lib, pkgs, ... }:

{
  programs.zathura = {
    enable = true;
    options = {
      font = "JetBrainsMono Nerd Font 8";
      
      continuous-hist-save = true;
      selection-clipboard = "clipboard";
      
      window-title-basename = true;
      statusbar-home-tilde = true;

      page-cache-size = 20;
      page-thumbnail-size = 67108864; # 64M
      
      ### THEME ###

      adjust-open = lib.mkForce "best-fit";
      guioptions = lib.mkForce "";

      page-padding = 2;

      recolor = true;
      recolor-keephue = true;
      recolor-reverse-video = true;
    };
    mappings = {
      z = ''set "default-bg \#1e1e2e"'';
      Z = ''set "default-bg \#181825"'';
    };
  };
}
