{ config, lib, pkgs, ... }:

let
  slippiPath = "${config.home.homeDirectory}/media/games/slippi";
  replayPath = "${slippiPath}/replays";
  # meleeHdTextures = pkgs.fetchzip {
  #   url = "https://download2270.mediafire.com/s59rsthvonhgmAyTx74rytPal4EY6XJox4sgEtEAGh7zfz2y_EXL4SWn-nn-uT6zD2nGUDtEwUwYEqFjRXxiYZhSJHAEM10i38U5u8XnIu1UhD6j0rjgpr3xvZgYlFFq7YVLRRlzAiAC-OETnallCD-9dGzx1BL6glhR0_0h9C4/4embgcgt2wcc6q0/Melee+HD+Texture+Pack+for+Dolphin+and+Slippi.zip";
  #   hash = "sha256-/Lip+cAEPUx7kMXMd8usx1L54q3W5YJePMUQTWPPBQg=";
  # };
in {
  slippi.launcher = {
    enable = true;
    isoPath = "${slippiPath}/ssbm-1.02-ntsc.iso";
    rootSlpPath = "${replayPath}/dump";
    useMonthlySubfolders = false;
    spectateSlpPath = "${replayPath}/spectated";
    extraSlpPaths = [ "${replayPath}/favorite" "${replayPath}/bracket" ];
  };

  slippi.netplay.enable = true;

  # xdg.configFile."SlippiOnline/Load/Textures/GALE01" = {
  #   source = "${meleeHdTextures}";
  #   recursive = true;
  # };
  #
  # xdg.configFile."SlippiPlayback/Load/Textures/GALE01" = {
  #   source = "${meleeHdTextures}";
  #   recursive = true;
  # };
}
