{ config, lib, pkgs, ... }:

{
  programs.gamemode.enable = true;
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    gamescopeSession.enable = true;
    gamescopeSession.args = [ "--adaptive-sync" ];
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-unwrapped"
    "steam-run"
  ];

  hardware.graphics.enable32Bit = true;
  environment.systemPackages = with pkgs; [
    (wineWow64Packages.full.override {
      wineRelease = "staging";
      mingwSupport = true;
      waylandSupport = true;
    })
    winetricks
    libstrangle
  ];
}
