{ config, lib, pkgs, ... }:

{
  programs.fish.enable = true;
  users.users.mrbjarksen = {
    isNormalUser = true;
    description = "Bjarki B. Harksen";
    createHome = true;
    home = "/home/mrbjarksen";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.fish;
  };
}
