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
    options = [
        { short = "P", long = "picker", arg = "required" },
        { short = "F", long = "nixpkgs-flake", arg = "required" },
        { short = "c", long = "print-completions", arg = "required" },
        { long = "cache-level", arg = "required" },
    ]

    [[highlighting.precommands]]
    name = "gamemoderun"
    mode = "default"

    [[highlighting.precommands]]
    name = "gamescope"
    mode = "default"
    options = [
        { short = "W", long = "output-width", arg = "required" },
        { short = "H", long = "output-height", arg = "required" },
        { short = "w", long = "nested-width", arg = "required" },
        { short = "h", long = "nested-height", arg = "required" },
        { short = "r", long = "nested-refresh", arg = "required" },
        { short = "m", long = "max-scale", arg = "required" },
        { short = "S", long = "scaler", arg = "required" },
        { short = "F", long = "filter", arg = "required" },
        { long = "sharpness", arg = "required" },
        { long = "fsr-sharpness", arg = "required" },
        { short = "s", long = "mouse-sensitivity", arg = "required" },
        { long = "backend", arg = "required" },
        { long = "cursor", arg = "required" },
        { long = "stats-path", arg = "required" },
        { short = "C", long = "hide-cursor-delay", arg = "required" },
        { long = "xwayland-count", arg = "required" },
        { long = "prefer-vk-device", arg = "required" },
        { long = "force-orientation", arg = "required" },
        { long = "cursor-scale-height", arg = "required" },
        { long = "virtual-connector-strategy", arg = "required" },
        { long = "sdr-gamut-wideness", arg = "required" },
        { long = "hdr-sdr-content-nits", arg = "required" },
        { long = "hdr-itm-target-nits", arg = "required" },
        { long = "framerate-limit", arg = "required" },
        { short = "o", long = "nested-unfocused-refresh", arg = "required" },
        { long = "display-index", arg = "required" },
        { short = "O", long = "prefer-output", arg = "required" },
        { long = "default-touch-mode", arg = "required" },
        { long = "generate-drm-mode", arg = "required" },
        { long = "vr-overlay-key", arg = "required" },
        { long = "vr-app-overlay-key", arg = "required" },
        { long = "vr-overlay-explicit-name", arg = "required" },
        { long = "vr-overlay-default-name", arg = "required" },
        { long = "vr-overlay-icon", arg = "required" },
        { long = "vr-overlay-physical-width", arg = "required" },
        { long = "vr-overlay-physical-curvature", arg = "required" },
        { long = "vr-overlay-physical-pre-curve-pitch", arg = "required" },
        { long = "vr-scrolls-speed", arg = "required" },
        { long = "reshade-effect", arg = "required" },
        { long = "reshade-technique-idx", arg = "required" },
        { long = "mura-map", arg = "required" },
    ]

    [[highlighting.precommands]]
    name = "nvidia-offload"
    mode = "default"
    options = [
        { short = "a", arg = "required" },
    ]
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
