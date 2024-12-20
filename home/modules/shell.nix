{ config, lib, pkgs, ... }:

{
  programs.fish = {
    enable = true;
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

  programs.atuin = {
    enable = true;
    daemon.enable = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      db_path = "${config.xdg.dataHome}/atuin/history.db";
      key_path = "${config.xdg.dataHome}/atuin/atuin-key";
      session_path = "${config.xdg.dataHome}/atuin/atuin-session";
      daemon.socket_path = "${config.xdg.dataHome}/atuin/atuin.sock";

      update_check = false;
      style = "compact";
      enter_accept = false;
      keymap_mode = "auto";
      keys.scroll_exits = false;
    };
    # ... add theme ...
  };

  # programs.bat.enable = true;
  # programs.carapace.enable = true;
  # programs.dircolors.enable = true;
}
