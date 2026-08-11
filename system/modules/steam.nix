{ config, lib, pkgs, ... }:

{
  programs.gamemode.enable = false;
  programs.gamescope = {
    enable = true;
    capSysNice = false;
  };

  programs.steam.enable = true;
  programs.steam.gamescopeSession = {
    enable = true;
    args = [ "--adaptive-sync" "--hdr-enabled" ];
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
