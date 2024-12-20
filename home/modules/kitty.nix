{ config, lib, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    font.name = "JetBrainsMono Nerd Font";
    font.size = 8;
    settings = {
      disable_ligatures = "cursor";
      cursor_shape = "beam";
      cursor_blink_interval = "0";
      wheel_scroll_multiplier = "3.0";
      mouse_hide_wait = "0";
      url_style = "single";
      strip_trailing_space = "smart";
      focus_follows_mouse = "yes";
      window_margin_width = "3.0";
      single_window_margin_width = "-1";
      hide_window_decorations = "yes";
      resize_debounce_time = "0.05";
    };
    themeFile = "tokyo_night_night";
    extraConfig = "cursor none";
  };
}
