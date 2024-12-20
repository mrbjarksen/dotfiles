{ config, lib, pkgs, ... }:

{
  programs.niri.settings = {
    prefer-no-csd = true;
    screenshot-path = "${config.xdg.userDirs.pictures}/screenshots/%Y-%m-%d-%H-%M-%S.png";
    hotkey-overlay.skip-at-startup = true;

    environment = {
      NIXOS_OZONE_WL = "1";

      XDG_SESSION_TYPE = "wayland";
      GDK_BACKEND = "wayland,x11,*";
      QT_QPA_PLATFORM = "wayland;xcb";
      SDL_VIDEO_DRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";

      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    };

    cursor = {
      theme = config.home.pointerCursor.name;
      size = config.home.pointerCursor.size;
      hide-when-typing = true;
    };

    input = {
      keyboard = {
        xkb = {
          layout = config.home.keyboard.layout;
          variant = config.home.keyboard.variant;
          options = lib.concatStringsSep "," config.home.keyboard.options;
        };
        track-layout = "global";

        repeat-delay = 400;
        repeat-rate = 25;
      };

      touchpad = {
        tap = true;
        dwt = true;
        natural-scroll = true;
        accel-speed = 0.2;
        scroll-method = "two-finger";
        tap-button-map = "left-right-middle";
        click-method = "clickfinger";
      };

      mouse = {
        accel-speed = 0.2;
      };

      focus-follows-mouse = {
        enable = true;
        max-scroll-amount = "34%";
      };

      workspace-auto-back-and-forth = true;
    };

    # output."eDP-1" = {
    #   mode = "3840x2400";
    #   scale = 2;
    #   transform = "normal";
    # };

    layout = {
      center-focused-column = "never";
      always-center-single-column = true;

      default-column-width.proportion = 0.7;
      preset-column-widths = [
        { proportion = 0.3; }
        { proportion = 0.5; }
        { proportion = 0.7; }
        { proportion = 1.0; }
      ];
      preset-window-heights = [
        { proportion = 0.3; }
        { proportion = 0.5; }
        { proportion = 0.7; }
        { proportion = 1.0; }
      ];

      focus-ring.enable = false;
      border = {
        enable = true;
        width = 1;
        active.color = "#7aa2f7";
        inactive.color = "#292e42";
      };

      gaps = 10;
      struts = {
        left = 0; right = 0;
        top = 30; bottom = 30;
      };
    };

    window-rules = [
      { geometry-corner-radius = 3; clip-to-geometry = true; }
      { match.app-id = "firefox"; default-column-width.proportion = 1.0; }
    ];

    animations = {};

    workspaces."1" = {};
    workspaces."2" = {};
    workspaces."3" = {};
    workspaces."4" = {};
    workspaces."5" = {};
    workspaces."6" = {};
    workspaces."7" = {};
    workspaces."8" = {};
    workspaces."9" = {};
    workspaces."0" = {};

    binds = with config.lib.niri.actions; let
      allowWhenLocked = action: { allow-when-locked = true; inherit action; };
      noRepeat = action: { repeat = false; inherit action; };
    in {
      "Mod+Shift+Apostrophe".action = show-hotkey-overlay;
      "Mod+T" = noRepeat (spawn config.home.sessionVariables.TERM);

      XF86AudioRaiseVolume = allowWhenLocked (spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+");
      XF86AudioLowerVolume = allowWhenLocked (spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-");
      XF86AudioMute = allowWhenLocked (spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle");
      XF86AudioMicMute = allowWhenLocked (spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle");

      "Mod+Q" = noRepeat close-window;

      "Mod+H".action = focus-column-left;
      "Mod+J".action = focus-window-down;
      "Mod+K".action = focus-window-up;
      "Mod+L".action = focus-column-right;

      "Mod+Ctrl+H".action = move-column-left;
      "Mod+Ctrl+J".action = move-window-down;
      "Mod+Ctrl+K".action = move-window-up;
      "Mod+Ctrl+L".action = move-column-right;

      "Mod+G".action = focus-column-first;
      "Mod+Shift+G".action = focus-column-last;
      "Mod+Ctrl+G".action = move-column-to-first;
      "Mod+Ctrl+Shift+G".action = move-column-to-last;

      "Mod+D".action = focus-workspace-down;
      "Mod+U".action = focus-workspace-up;
      "Mod+Ctrl+D".action = move-column-to-workspace-down;
      "Mod+Ctrl+U".action = move-column-to-workspace-up;

      # "Mod+Ctrl+Shift+D".action = move-workspace-down;
      # "Mod+Ctrl+Shift+U".action = move-workspace-up;

      "Mod+1".action = focus-workspace "1";
      "Mod+2".action = focus-workspace "2";
      "Mod+3".action = focus-workspace "3";
      "Mod+4".action = focus-workspace "4";
      "Mod+5".action = focus-workspace "5";
      "Mod+6".action = focus-workspace "6";
      "Mod+7".action = focus-workspace "7";
      "Mod+8".action = focus-workspace "8";
      "Mod+9".action = focus-workspace "9";
      "Mod+0".action = focus-workspace "0";
      "Mod+Ctrl+1".action = move-column-to-workspace "1";
      "Mod+Ctrl+2".action = move-column-to-workspace "2";
      "Mod+Ctrl+3".action = move-column-to-workspace "3";
      "Mod+Ctrl+4".action = move-column-to-workspace "4";
      "Mod+Ctrl+5".action = move-column-to-workspace "5";
      "Mod+Ctrl+6".action = move-column-to-workspace "6";
      "Mod+Ctrl+7".action = move-column-to-workspace "7";
      "Mod+Ctrl+8".action = move-column-to-workspace "8";
      "Mod+Ctrl+9".action = move-column-to-workspace "9";
      "Mod+Ctrl+0".action = move-column-to-workspace "0";

      "Mod+Comma" .action = consume-or-expel-window-left;
      "Mod+Period".action = consume-or-expel-window-right;

      "Mod+R" = noRepeat switch-preset-column-width;
      "Mod+Shift+R" = noRepeat switch-preset-window-height;
      "Mod+Ctrl+R" = noRepeat reset-window-height;
      "Mod+F" = noRepeat maximize-column;
      "Mod+Shift+F" = noRepeat fullscreen-window;
      "Mod+C" = noRepeat center-column;

      "Print".action = screenshot;
      "Ctrl+Print".action = screenshot-screen;
      "Alt+Print".action = screenshot-window; 

      "Mod+Shift+E".action = quit;
    };
  };
}
