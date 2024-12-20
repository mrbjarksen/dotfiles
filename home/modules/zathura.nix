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
      
      # adjust-open = lib.mkDefault "width";
      # guioptions = lib.mkDefault "";

      ### THEME ###

      adjust-open = lib.mkForce "best-fit";
      guioptions = lib.mkForce "s";

      page-padding = 2;

      recolor = true;
      recolor-keephue = true;
      recolor-reverse-video = true;

      recolor-darkcolor = "#c0caf5";
      recolor-lightcolor = "#1a1b26";

      default-bg = "#1a1b26";
      default-fg = "#c0caf5";

      statusbar-bg = "#16161e";
      statusbar-fg = "#c0caf5";

      inputbar-bg = "#16161e";
      inputbar-fg = "#c0caf5";

      completion-bg = "#16161e";
      completion-fg = "#c0caf5";
      completion-group-bg = "#16161e";
      completion-group-fg = "#c0caf5";
      completion-highlight-bg = "#343a55";
      completion-highlight-fg = "#c0caf5";

      notification-bg = "#16161e";
      notification-fg = "#0db9d7";
      notification-error-bg = "#16161e";
      notification-error-fg = "#db4b4b";
      notification-warning-bg = "#16161e";
      notification-warning-fg = "#e0af68";

      highlight-color = "#3d59a1";
      highlight-fg = "#3d59a1";
      highlight-active-color = "#ff9e64";

      render-loading-bg = "#16161e";
      render-loading-fg = "#c0caf5";

      index-bg = "#16161e";
      index-fg = "#c0caf5";
      index-active-bg = "#292e42";
      index-active-fg = "#c0caf5";
    };
    mappings = {
      z = ''set "default-bg \#1a1b26"'';
      Z = ''set "default-bg \#c0caf5"'';
    };
  };
}
