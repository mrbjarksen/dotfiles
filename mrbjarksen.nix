{ config, pkgs, ... }:

let
  font = "JetBrainsMono Nerd Font";
  # theme = import ./themes/everblush;
  xdg = attr: builtins.replaceStrings [ "~/" config.home.homeDirectory ] [ "" "" ] config.xdg.${attr};
in
{
  home.username = "mrbjarken";
  home.homeDirectory = "/home/mrbjarksen";
  home.stateVersion = "22.05";
  programs.home-manager.enable = true;

  home.sessionPath = [ "$HOME/.local/bin" ];
  home.packages = with pkgs; [
    gh
    bat
    btop
    neovim
    xmobar
    nerdfonts
    firefox
  ];

  home.keyboard = {
    layout = "is,us";
    options = [ "grp:caps_toggle" ];
  };

  home.language = {
    base        = "en_US-UTF-8";
    time        = "en_GB-UTF-8";
    collate     = "is_IS.UTF-8";
    monetary    = "is_IS.UTF-8";
    paper       = "is_IS.UTF-8";
    name        = "is_IS.UTF-8";
    address     = "is_IS.UTF-8";
    telephone   = "is_IS-UTF-8";
    measurement = "is_IS.UTF-8";
  };

  home.pointerCursor = {
    package = pkgs.nordzy-cursor-theme;
    name = "Nordzy-cursors-white";
    size = 15;
    x11.enable = true;
    gtk.enable = true;
  };

  home.sessionVariables = {
    TERM = "xterm-kitty";
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "firefox";
  };

  fonts.fontconfig.enable = true;

  xdg.enable = true;
  xdg.configFile = {
    xmonad = { source = ./xmonad; recursive = true; };
    xmobar = { source = ./xmobar; recursive = true; };
    nvim   = { source = ./nvim;   recursive = true; };
  };

  services.picom = {
    enable = true;
    backend = "glx";
    fade = true;
    settings = {
      blur.method = "dual-kawase";
    };
  };

  xsession = {
    enable = true;
    # profilePath = "${xdg "configHome"}/X11/.xprofile";
    # scriptPath = "${xdg "configHome"}/X11/.xsession";
  };
  # xresources.path = "${config.xdg.configHome}/X11/.Xresources";

  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };

  programs.kitty = {
    enable = true;
    font.name = font;
    font.size = 19;
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
      resize_debounce_time = "0.05";
    };
    theme = "Tokyo Night";
  };

  programs.zsh = {
    enable = true;
    dotDir = "${xdg "configHome"}/zsh";

    defaultKeymap = "viins";

    history = {
      extended = true;
      path = "${config.xdg.stateHome}/zsh/history";
    };

    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;

    initExtra = ''
      setopt AUTO_CD
      setopt LIST_PACKED
      setopt INTERACTIVE_COMMENTS
      unsetopt BEEP

      autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search

      bindkey -- '^[[A' up-line-or-beginning-search
      bindkey -- '^[[B' down-line-or-beginning-search

      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
      ZVM_VI_ESCAPE_BINDKEY=jk

      source ${pkgs.zsh-bd}/share/zsh-bd/zsh-bd.plugin.zsh
      source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh

      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    '';
  };

  programs.git = {
    enable = true;
    userName = "Bjarki Baldursson Harksen";
    userEmail = "bjarki31@gmail.com";
    extraConfig = {
      init = { defaultBranch = "main"; };
      url = { "https://github.com/" = { insteadOf = [ "gh:" "github:" ]; }; };
    };
    delta.enable = true;
  };

  programs.lsd = {
    enable = true;
    enableAliases = true;
  };

  programs.zathura = {
    enable = false;
    options = {
      inherit font;
      adjust-open = "width";
      recolor-keephue = true;
      recolor-reverse-video = true;
      statusbar-home-tilde = true;
      guioptions = "";
      continuous-hist-save = true;
      selection-clipboard = "clipboard";
    };
  };
}
