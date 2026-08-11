{ config, lib, pkgs, ... }:

{
  programs.niri.settings = {
    prefer-no-csd = true;
    screenshot-path = "${config.xdg.userDirs.pictures}/screenshots/%Y-%m-%d-%H.%M.%S.png";
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

    xwayland-satellite = {
      enable = true;
      path = "${lib.getExe pkgs.xwayland-satellite}";
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

      focus-follows-mouse = {
        enable = true;
        max-scroll-amount = "34%";
      };

      workspace-auto-back-and-forth = true;
    };

    overview = {
      backdrop-color = "#11111b";
      zoom = 0.75;
    };

    # recent-windows.off = true;

    outputs."Sharp Corporation 0x14D6 Unknown" = {
      mode = {
        width = 3840;
        height = 2400;
      };
      scale = 2;
    };

    outputs."Lenovo Group Limited Qreator27 U310Y6F9" = {
      mode = {
        width = 3840;
        height = 2160;
      };
      scale = 1.5;
      variable-refresh-rate = true;
    };

    outputs."LG Electronics LG TV SSCR2 0x01010101" = {
      mode = {
        width = 3840;
        height = 2160;
        refresh = 120.000;
      };
      scale = 2;
      variable-refresh-rate = true;
    };

    layout = {
      background-color = "#11111b";

      center-focused-column = "never";

      default-column-width.proportion = 0.5;
      preset-column-widths = [
        { proportion = 0.7; }
        { proportion = 0.5; }
        { proportion = 0.3; }
      ];
      preset-window-heights = [
        { proportion = 0.7; }
        { proportion = 0.5; }
        { proportion = 0.3; }
      ];

      focus-ring.enable = false;
      border = {
        enable = true;
        width = 1;
        active.color = "#7f849c";
        inactive.color = "#313244";
      };

      gaps = 3;
      struts = {
        left = 0; right = 0;
        top = 0; bottom = 0; # 30
      };
    };

    window-rules = [
      {
        geometry-corner-radius = let
          corner-radius = 6.0;
        in {
          bottom-left = corner-radius;
          bottom-right = corner-radius;
          top-left = corner-radius;
          top-right = corner-radius;
        };
        clip-to-geometry = true;
      }
      {
        matches = [ { app-id = "firefox$"; } ];
        default-column-width.proportion = 1.0;
      }
      {
          matches = [ { app-id = "firefox$"; title = "^Picture-in-Picture$"; } ];
          open-floating = true;
          open-focused = false;
          default-floating-position = { x = 10; y = 10; relative-to = "top-right"; };
          default-column-width.fixed = 25 * 16;
          default-window-height.fixed = 25 * 9;
      }
      {
        matches = [ { app-id = "sol"; } ];
        open-on-output = "HDMI-A-2";
        open-fullscreen = true;
        open-focused = true;
      }
    ];

    animations = {
      window-open.kind.easing.duration-ms = 150;
      window-open.kind.easing.curve = "ease-out-cubic";
      window-open.custom-shader = ''
        vec4 open_color(vec3 coords_geo, vec3 size_geo) {
          if (coords_geo.x < 0.0) return vec4(0.0);

          float left_edge_pixels = min(6.0, niri_clamped_progress * size_geo.x / 2.0);
          if (coords_geo.x * size_geo.x > left_edge_pixels)
            coords_geo.x += 1.0 - niri_clamped_progress;

          vec3 coords_tex = niri_geo_to_tex * coords_geo;
          return texture2D(niri_tex, coords_tex.st);
        }
      '';
      window-close.kind.easing.duration-ms = 150;
      window-close.kind.easing.curve = "ease-out-cubic";
      window-close.custom-shader = ''
        vec4 close_color(vec3 coords_geo, vec3 size_geo) {
          if (coords_geo.x < 0.0) return vec4(0.0);

          float left_edge_pixels = min(6.0, (1.0 - niri_clamped_progress) * size_geo.x / 2.0);
          if (coords_geo.x * size_geo.x > left_edge_pixels)
            coords_geo.x += niri_clamped_progress;

          vec3 coords_tex = niri_geo_to_tex * coords_geo;
          return texture2D(niri_tex, coords_tex.st);
        }
      '';
    };

    binds = with config.lib.niri.actions; let
      allowWhenLocked = action: { allow-when-locked = true; inherit action; };
      noRepeat = action: { repeat = false; inherit action; };
      wpctl = "${pkgs.wireplumber}/bin/wpctl";
    in lib.mkForce {
      "Mod+Shift+Apostrophe".action = show-hotkey-overlay;

      "XF86AudioRaiseVolume".action.spawn = [ wpctl "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+" ];
      "XF86AudioLowerVolume".action.spawn = [ wpctl "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-" ];
      "XF86AudioMute".action.spawn = [ wpctl "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ];
      "XF86AudioMicMute".action.spawn = [ wpctl "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle" ];

      "Mod+Space".action.spawn = [ "dms" "ipc" "spotlight-bar" "toggleWith" "all" ];

      "Mod+T" = noRepeat (spawn config.home.sessionVariables.TERM);
      "Mod+B" = noRepeat (spawn config.home.sessionVariables.BROWSER);

      "Mod+Q" = noRepeat close-window;

      "Mod+End".action.spawn = [ "loginctl" "lock-session" ];

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

      "Mod+Ctrl+M".action = move-window-to-monitor-next;

      "Mod+Comma"= noRepeat consume-or-expel-window-left;
      "Mod+Period" = noRepeat consume-or-expel-window-right;

      "Mod+Tab" = noRepeat switch-focus-between-floating-and-tiling;
      "Mod+Ctrl+Tab" = noRepeat toggle-window-floating;
      "Mod+W" = noRepeat toggle-column-tabbed-display;

      "Mod+R" = noRepeat switch-preset-column-width;
      "Mod+Shift+R" = noRepeat switch-preset-window-height;
      "Mod+Ctrl+R" = noRepeat reset-window-height;
      "Mod+F" = noRepeat maximize-column;
      "Mod+Shift+F" = noRepeat fullscreen-window;
      "Mod+Ctrl+F" = noRepeat toggle-windowed-fullscreen;
      "Mod+C" = noRepeat center-visible-columns;
      "Mod+E" = noRepeat expand-column-to-available-width;

      "Mod+O" = noRepeat toggle-overview;

      # "Mod+Shift+S".action = screenshot;
      # "Mod+Ctrl+S".action = screenshot-screen;
      # "Mod+Shift+Ctrl+S".action = screenshot-window; 

      "Mod+Escape" = noRepeat toggle-keyboard-shortcuts-inhibit;
      "Mod+Shift+E" = noRepeat quit;
    };
  };
}
