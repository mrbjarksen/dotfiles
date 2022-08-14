{ config, pkgs, ... }:

let
  font = "JetBrainsMono Nerd Font";
  # theme = import ./themes/everblush;
  xdg = attr: builtins.replaceStrings [ "~/" "/home/mrbjarksen/" ] [ "" "" ] config.xdg.${attr};
in
{
  home.username = "mrbjarken";
  home.homeDirectory = "/home/mrbjarksen";
  home.stateVersion = "22.05";
  programs.home-manager.enable = true;

  home.sessionPath = [ "$HOME/.local/bin" ];
  home.packages = with pkgs; [
    bat
    btop
    nerdfonts
    firefox
  ];

  xdg.enable = true;
  xdg.configFile = {
    xmonad = { source = ./xmonad; recursive = true; };
    xmobar = { source = ./xmobar; recursive = true; };
    nvim   = { source = ./nvim;   recursive = true; };
  };

  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };
  programs.xmobar.enable = true;

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

    autocd = true;
    defaultKeymap = "viins";

    history = {
      extended = true;
      path = "${config.xdg.stateHome}/zsh/history";
    };

    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;

    initExtra = ''
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

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
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
  programs.gh.enable = true;

  programs.lsd = {
    enable = true;
    enableAliases = true;
  };

  programs.zathura = {
    enable = true;
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
