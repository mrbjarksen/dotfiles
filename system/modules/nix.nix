{ config, lib, pkgs, inputs, ... }:

{
  nix.package = pkgs.nix;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep 5 --keep-since 30d --optimise";
  };

  nix.registry = (lib.mapAttrs (_: value: { flake = value; }) inputs) // {
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

  nix.nixPath = lib.mapAttrsToList (key: value: "${key}=${value.outPath}") inputs;
}
