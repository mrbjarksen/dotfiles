{ config, lib, pkgs, ... }:

{
  programs.zsh.enable = true;
  environment.pathsToLink = [ "/share/zsh" ];
  users.users.mrbjarksen = {
    isNormalUser = true;
    description = "Bjarki B. Harksen";
    createHome = true;
    home = "/home/mrbjarksen";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };
}
