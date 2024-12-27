{ config, lib, pkgs, ... }:

{
  programs.gamemode.enable = true;
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-unwrapped"
    "steam-run"
  ];

  environment.systemPackages = with pkgs; [ mangohud ];
}
