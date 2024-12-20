{ config, lib, pkgs, ... }:

{
  nix.package = pkgs.nix;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.channel.enable = false;

  nix.gc = {
    automatic = true;
    dates = "05:00";
    options = "--delete-older-than 7d";
  };
  nix.optimise = {
    automatic = true;
    dates = [ "06:00" ];
  };

  nix.registry.nixpkgs.flake = pkgs;
  nix.registry."dotfiles" = {
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

  environment.etc."nix/inputs/nixpkgs".source = "${pkgs}";
}
