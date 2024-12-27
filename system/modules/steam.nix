{ config, lib, pkgs, ... }:

{
  programs.gamemode.enable = true;
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  environment.systemPackages = with pkgs; [ mangohud ];
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    gamescopeSession.args = [ "--mangoapp" ];
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-unwrapped"
    "steam-run"
  ];
}
