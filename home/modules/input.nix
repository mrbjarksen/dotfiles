{ config, lib, pkgs, ... }:

{
  home.keyboard = {
    layout = "is,us";
    variant = "mac,";
    options = [ "caps:escape" "grp:menu_escape" "grp_led:caps" ];
  };

  home.pointerCursor = {
    # package = pkgs.vimix-cursors;
    # name = "Vimix-cursors";
    package = pkgs.rose-pine-cursor;
    name = "BreezeX-RosePineDawn-Linux";
    size = 22;
  };
}
