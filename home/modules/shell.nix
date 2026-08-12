{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    completionInit = ''
      autoload -U compinit && compinit
      zstyle ':completion:*' menu select
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
    '';

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    defaultKeymap = "viins";

    history.extended = true;
    history.ignoreDups = true;
    history.save = 1000000;
    history.size = 1000000;

    dotDir = "${config.xdg.configHome}/zsh";
    history.path = "${config.xdg.dataHome}/zsh/zsh_history";

    setOptions = [
      "AUTO_CD"
      "LIST_PACKED"
      "INTERACTIVE_COMMENTS"
      "NO_BEEP"
    ];

    initContent = lib.mkMerge [
      # (lib.mkOrder 550 ''
      #   fpath+=(/home/mrbjarksen/projects/harkprompt)
      #
      #   setopt TRANSIENT_RPROMPT
      #   PROMPT_HARK_SHLVL_OFFSET=-1
      #
      #   autoload -U promptinit && promptinit
      #   prompt hark catppuccin-mocha
      # '')
      ''
        bindkey -v '^?' backward-delete-char

        autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
        zle -N up-line-or-beginning-search
        zle -N down-line-or-beginning-search

        bindkey -a 'k' up-line-or-beginning-search
        bindkey -a 'j' down-line-or-beginning-search
        [[ -n "$key[Up]" ]] && bindkey -- "$key[Up]" up-line-or-beginning-search
        [[ -n "$key[Up]" ]] && bindkey -- "$key[Down]" down-line-or-beginning-search

        function add-dot-and-resolve-abbr() {
          [[ $LBUFFER = *.. ]] && LBUFFER+=/.
          LBUFFER+=.
        }
        zle -N add-dot-and-resolve-abbr
        bindkey -v . add-dot-and-resolve-abbr
      ''
      (lib.mkAfter ''
        eval "$(${pkgs.zsh-patina}/bin/zsh-patina completion)"
        eval "$(${pkgs.zsh-patina}/bin/zsh-patina activate)"
      '')
    ];

    plugins = [
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
      {
        name = "bd";
        src = pkgs.zsh-bd;
        file = "share/zsh-bd/zsh-bd.plugin.zsh";
      }
    ];

    harkprompt = {
      enable = true;
      theme = "catppuccin-mocha";
    };
  };

  xdg.configFile."zsh-patina/config.toml".text = ''
    [highlighting]
    theme = "catppuccin-mocha"

    [[highlighting.precommands]]
    name = ","
    mode = "default"

    [[highlighting.precommands]]
    name = "gamemoderun"
    mode = "default"

    [[highlighting.precommands]]
    name = "gamescope"
    mode = "default"

    [[highlighting.precommands]]
    name = "nvidia-offload"
    mode = "default"
  '';

  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
  };

  programs.bat = {
    enable = true;
    config = {
      tabs = "8";
      style = "numbers";
    };
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = false; # Turn off built-in aliases
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
  };

  home.shellAliases = {
    ls = lib.mkIf config.programs.eza.enable "eza";
    ll = if config.programs.eza.enable then "eza -la" else "ls -Flah";
    tree = lib.mkIf config.programs.eza.enable "eza -la --tree";
  };

  home.sessionVariables = {
    TERM = "kitty";
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "firefox";
  };

  # programs.atuin = {
  #   enable = true;
  #   enableZshIntegration = true;
  #   daemon.enable = true;
  #   flags = [ "--disable-up-arrow" ];
  #   settings = {
  #     db_path = "${config.xdg.dataHome}/atuin/history.db";
  #     key_path = "${config.xdg.dataHome}/atuin/key";
  #     session_path = "${config.xdg.dataHome}/atuin/session";
  #     daemon = {
  #       enable = true;
  #       socket_path = "${config.xdg.dataHome}/atuin/atuin.sock";
  #     };
  #
  #     dialect = "uk";
  #     style = "compact";
  #     enter_accept = false;
  #     keymap_mode = "auto";
  #     keys.scroll_exits = false;
  #
  #     records = true;
  #     update_check = true;
  #     dotfiles = false;
  #   };
  #   # ... add theme ...
  # };

  # programs.carapace.enable = true;
  # programs.dircolors.enable = true;
}
