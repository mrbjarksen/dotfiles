{ config, lib, pkgs, ... }:

{
  programs.home-manager.enable = true;
  manual.json.enable = true;

  home.packages = with pkgs; [
    go
    cargo
    zig
    nodejs
    typescript
    tree-sitter
    ripgrep
    fzf
  ];

  home.language = {
    base = "en_US.UTF-8";

    time        = "en_DK.UTF-8";
    collate     = "is_IS.UTF-8";
    monetary    = "is_IS.UTF-8";
    paper       = "is_IS.UTF-8";
    telephone   = "is_IS-UTF-8";
    measurement = "is_IS.UTF-8";

    ctype    = "en_US.UTF-8";
    messages = "en_US.UTF-8";
    address  = "en_US.UTF-8";
    name     = "en_US.UTF-8";
  };

  programs.firefox.enable = true; # <-
  programs.imv.enable = true; # <-
  programs.mpv.enable = true; # <-

  services.playerctld.enable = true;
  services.mpris-proxy.enable = true;

  programs.wpaperd = { # <-
    enable = true;
    settings.any.path = "${config.xdg.userDirs.pictures}/wallpapers";
  };
  services.dunst.enable = true;

  services.cliphist.enable = true;

  programs.aria2 = {
    enable = true;
    settings = {
      dir = config.xdg.userDirs.download;
      show-files = true;
    };
  };

  programs.nix-index.enable = true;
}
