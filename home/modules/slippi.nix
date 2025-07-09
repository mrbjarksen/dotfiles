{ config, lib, pkgs, ... }:

{
  ssbm.slippi-launcher = true;
  iso-path = "${config.home.homeDirectory}/media/games/ssbm/ssbm-1.02-ntsc.iso";
}
