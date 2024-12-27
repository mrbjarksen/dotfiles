{ config, lib, pkgs, ... }:

{
  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
    settings = {
      fps = true;

      cpu_stats = true;
      ram = true;
      
      gpu_stats = true;
      vram = true;
      throttling_status = true;

      font_size = 6;
      hud_compact = true;
      hud_no_margin = true;
      horizontal = true;
    };
  };
}
