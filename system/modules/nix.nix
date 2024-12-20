{ config, lib, pkgs, inputs, ... }:

let
  inputRegistries = lib.mapAttrs (_: value: { flake = value; }) inputs;
in {
  nix.package = pkgs.nix;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc = {
    automatic = true;
    dates = "05:00";
    options = "--delete-older-than 7d";
  };
  nix.optimise = {
    automatic = true;
    dates = [ "06:00" ];
  };

  nix.registry = inputRegistries // {
    dotfiles = {
      from = {
        type = "indirect";
        id = "dotfiles";
      };
      to = {
        type = "github";
        owner = "mrbjarksen";
        repo = "dotfiles";
      };
    };
  };

  nix.nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") inputRegistries;
}
