{ config, lib, pkgs, ... }:

let
  slippiPath = "${config.home.homeDirectory}/media/games/slippi";
in {
  ssbm.slippi-launcher = {
    enable = true;
    isoPath = "${slippiPath}/ssbm-1.02-ntsc.iso";
    rootSlpPath = "${slippiPath}/replays";
    useMonthlySubfolders = true;
    spectateSlpPath = "${config.ssbm.slippi-launcher.rootSlpPath}/spectator";
  };
}
