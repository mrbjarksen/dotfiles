{ config, pkgs, ... }:

let
  font = "JetBrainsMono Nerd Font";
  theme = import ./themes/tokyonight.nix;
  xdg = attr: builtins.replaceStrings [ "~/" "${config.home.homeDirectory}/" ] [ "" "" ] config.xdg.${attr};
in
{
  home.username = "mrbjarken";
  home.homeDirectory = "/home/mrbjarksen";
  home.stateVersion = "22.05";
  programs.home-manager.enable = true;
  home.enableNixpkgsReleaseCheck = true;

  home.sessionPath = [ "$HOME/.local/bin" ];
  home.packages = with pkgs; [
    gh
    bat
    btop
    ripgrep
    neovim
    xmobar
    nerdfonts
    firefox
    font-awesome
    material-icons
  ];

  home.keyboard = {
    layout = "is,us";
    options = [ "grp:caps_toggle" ];
  };

  home.language = {
    base        = "en_US.UTF-8";
    time        = "en_GB.UTF-8";
    collate     = "is_IS.UTF-8";
    monetary    = "is_IS.UTF-8";
    paper       = "is_IS.UTF-8";
    name        = "is_IS.UTF-8";
    address     = "is_IS.UTF-8";
    telephone   = "is_IS-UTF-8";
    measurement = "is_IS.UTF-8";
  };

  home.pointerCursor = {
    package = pkgs.nur.repos.ambroisie.vimix-cursors;
    name = "Vimix-cursors";
    # size = 15;
    # x11.enable = true;
    # gtk.enable = true;
  };

  home.sessionVariables = {
    TERM = "xterm-kitty";
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "firefox";

    NVIM_DEFAULT_THEME = theme.nvim.name;
  };

  fonts.fontconfig.enable = true;

  xdg.enable = true;
  xdg.configFile = {
    xmonad = { source = ./xmonad; recursive = true; };
    nvim   = { source = ./nvim;   recursive = true; };
  };

  services.picom = {
    enable = true;
    # backend = "glx";
    fade = true;
    fadeDelta = 1;
    activeOpacity = 0.99;
    inactiveOpacity = 0.8;
    menuOpacity = 0.99;
    settings = {
      blur.method = "dual-kawase";
      blur.strength = 20;
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
  programs.xmobar = {
    enable = true;
    extraConfig = builtins.readFile ./xmobar/xmobarrc;
  };

  programs.kitty = {
    enable = true;
    font.name = font;
    font.size = 9;
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
      source ${pkgs.zsh-bd}/share/zsh-bd/bd.plugin.zsh
      source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh

      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    '';
  };

  programs.git = {
    enable = true;
    userName = "Bjarki Baldursson Harksen";
    userEmail = "bjarki@harksen.is";
    extraConfig = {
      init = { defaultBranch = "main"; };
      url = { "https://github.com/" = { insteadOf = [ "gh:" "github:" ]; }; };
    };
    delta.enable = true;
  };

  programs.exa = {
    enable = true;
    enableAliases = true;
    git = true;
    extraOptions = [
      "--classify" # -F
      "--extended" # -@
    ];
  };

  programs.zathura = {
    enable = true;
    options = {
      inherit font;
      
      continuous-hist-save = true;
      selection-clipboard = "clipboard";
      
      window-title-basename = true;
      statusbar-home-tilde = true;

      page-cache-size = 20;
      page-thumbnail-size = 67108864; # 64M
      
      adjust-open = "width";
      guioptions = "";

      recolor-keephue = true;
      recolor-reverse-video = true;
    } // (if theme ? zathura.options then theme.zathura.options else {});
    mappings = if theme ? zathura.mappings then theme.zathura.mappings else {};
  };
}
