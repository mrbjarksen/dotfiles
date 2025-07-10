{ config, lib, pkgs, ... }:

{
  imports = [
    ./btop.nix
    ./common.nix
    ./fonts.nix
    ./git.nix
    ./input.nix
    ./kitty.nix
    ./mangohud.nix
    ./niri.nix
    ./shell.nix
    ./xdg.nix
    ./zathura.nix
  ];
}
