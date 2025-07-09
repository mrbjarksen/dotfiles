{ config, lib, pkgs, ... }:

{
  programs.gamemode.enable = true;
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  # environment.systemPackages = with pkgs; [ mangohud ];
  # environment.variables.MANGOHUD_CONFIGFILE = "${config.users.users.mrbjarksen.home}/.config/MangoHud/MangoHud.conf";
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
    (wineWowPackages.full.override {
      wineRelease = "staging";
      mingwSupport = true;
      waylandSupport = true;
    })
    winetricks
  ];
}
