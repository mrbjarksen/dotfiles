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

      bindkey -a 'k' up-line-or-beginning-search
      bindkey -a 'j' down-line-or-beginning-search
      [[ -n "$key[Up]" ]] && bindkey -- "$key[Up]" up-line-or-beginning-search
      [[ -n "$key[Up]" ]] && bindkey -- "$key[Down]" down-line-or-beginning-search
    '';

    plugins = [
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugins.zsh";
      }
    ];
  };

  programs.starship = {
    enable = true;
    configPath = "${config.xdg.configHome}/starship.toml";
    settings = {
      format = ''
        [🮈](fg:#45475b)$status$time$cmd_duration

        [🮈](fg:#45475b)$username$hostname$container$directory$git_branch$git_commit$git_state( [█](fg:#45475b)$git_status$git_metrics)
        [🮈](fg:#45475b) $shlvl$character
      '';
      add_newline = false;
      username = {
        format = "( [█  $user ]($style))";
        style_user = "fg:#cba6f8 bg:#38324d";
        style_root = "fg:#f38ba9 bg:#3e2e41";
        show_always = true;
        disabled = false;
      };
      hostname = {
        format = "( [█ 󰒋 $hostname ]($style))";
        style = "fg:#cba6f8 bg:#38324d";
        ssh_only = false;
        disabled = false;
      };
      container = {
        format = "( [█ 󰋘 $name]($style))";
        style = "fg:#cba6f8 bg:#38324d";
        disabled = false;
      };
      directory = {
        format = " [█ 󰉋 $path ]($style)";
        style = "fg:#89b4fa bg:#2e354d";
        truncation_length = 8;
        disabled = false;
      };
      git_branch = {
        format = "( [█  $branch ]($style))";
        style = "fg:#f38ba9 bg:#3e2e41";
        only_attached = true;
        disabled = false;
      };
      git_commit = {
        format = ''( [█  \($hash$tag\) ]($style))'';
        style = "fg:#f38ba9 bg:#3e2e41";
        tag_disabled = false;
        only_detached = true;
        disabled = false;
      };
      git_status = {
        format = "( [󰈚( $all_status)( $ahead_behind)]($style))";
        style = "fg:#45475b";
        conflicted = "=";
        ahead = "";
        behind = "";
        diverged = "";
        up_to_date = "";
        untracked = "?";
        stashed = "";
        modified = "M";
        staged = "A";
        renamed = "R";
        deleted = "D";
        typechanged = "T";
        disabled = false;
      };
      git_state = {
        format = "( [█ $state $progress_current/$progress_total ]($style))";
        style = "fg:#f9e2af bg:#3f3b42";
        disabled = false;
      };
      git_metrics = {
        format = "( [󰐖 $added]($added_style))( [󰍵 $deleted]($deleted_style))";
        added_style = "fg:#45475b";
        deleted_style = "fg:#45475b";
        disabled = false;
      };
      shlvl = {
        format = "[$symbol]($style)";
        style = "fg:#45475b";
        symbol = "";
        repeat = true;
        repeat_offset = 2;
        threshold = 3;
        disabled = false;
      };
      character = {
        success_symbol = ''[](fg:#a6e3a2)'';
        error_symbol = ''[](fg:#a6e3a2)'';
        vimcmd_symbol = ''[](fg:#89b4fa)'';
        vimcmd_replace_one_symbol = ''[](fg:#f38ba9)'';
        vimcmd_replace_symbol = ''[](fg:#f38ba9)'';
        vimcmd_visual_symbol = ''[](fg:#cba6f8)'';
        disabled = false;
      };
      status = {
        format = "( [█ $symbol$common_meaning$signal_name$maybe_int ]($style))";
        failure_style = "fg:#f38ba9 bg:#3e2e41";
        symbol = "● ";
        disabled = false;
      };
      time = {
        format = "( [█ 󰥔 $time]($style))";
        style = "fg:#45475b";
        disabled = false;
      };
      cmd_duration = {
        format = "( [󱎫 $duration]($style))";
        style = "fg:#45475b";
        min_time = 0;
        show_milliseconds = true;
        disabled = false;
      };
    };
  };

  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
    config.whitelist.prefix = [ "~/projects" ];
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
