{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    defaultKeymap = "viins";

    history.extended = true;
    history.ignoreDups = true;
    history.save = 1000000;
    history.size = 1000000;

    dotDir = "${config.xdg.configHome}/zsh";
    history.path = "${config.xdg.dataHome}/zsh/zsh_history";

    initContent = ''
      setopt AUTO_CD
      setopt LIST_PACKED
      setopt INTERACTIVE_COMMENTS
      unsetopt BEEP

      zsh_highlight+=(paste:none)

      zstyle ':completion:*' menu select

      bindkey -v '^?' backward-delete-char

      autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search

      bindkey -- '^[[A' up-line-or-beginning-search
      bindkey -- '^[[B' down-line-or-beginning-search
      bindkey -a 'k' up-line-or-beginning-search
      bindkey -a 'j' down-line-or-beginning-search
    '';

    plugins = [
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugins.zsh";
      }
    ];
  };

  # programs.starship.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config.whitelist.prefix = [ "~/dev" ];
  };

  programs.eza = {
    enable = true;
    git = true;
    icons = "auto";
    extraOptions = [
      "-F"
      "--octal-permissions"
      "--no-permissions"
      "--time-style=long-iso"
      "--git"
      "--git-repos"
    ];
    # ... add theme...
  };

  home.shellAliases = {
    ls = lib.mkIf config.programs.eza.enable "eza";
    ll = if config.programs.eza.enable then "eza -la --icons" else "ls -Flah";
    tree = lib.mkIf config.programs.eza.enable "eza -la --icons --tree";
  };

  home.sessionVariables = {
    TERM = "kitty";
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "firefox";
  };

  # programs.atuin = {
  #   enable = true;
  #   daemon.enable = true;
  #   flags = [ "--disable-up-arrow" ];
  #   settings = {
  #     db_path = "${config.xdg.dataHome}/atuin/history.db";
  #     key_path = "${config.xdg.dataHome}/atuin/atuin-key";
  #     session_path = "${config.xdg.dataHome}/atuin/atuin-session";
  #     daemon.socket_path = "${config.xdg.dataHome}/atuin/atuin.sock";
  #
  #     update_check = false;
  #     style = "compact";
  #     enter_accept = false;
  #     keymap_mode = "auto";
  #     keys.scroll_exits = false;
  #   };
  #   # ... add theme ...
  # };

  # programs.bat.enable = true;
  # programs.carapace.enable = true;
  # programs.dircolors.enable = true;
}
