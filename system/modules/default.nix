{ config, lib, pkgs, ... }:

{
  imports = [
    ./acpid.nix
    ./bluetooth.nix
    ./boot.nix
    ./common.nix
    ./disk
    ./greetd.nix
    ./input.nix
    ./networking.nix
    ./nix.nix
    ./pipewire.nix
    ./region.nix
    ./steam.nix
    ./users.nix
  ];
}
