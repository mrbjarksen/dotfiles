{ config, lib, pkgs, ... }:

{
  programs.mangohud = {
    enable = true;
    settings = {
      fps = true;
      frametime = false;
      frame_timing = false;

      cpu_stats = true;
      ram = true;

      gpu_stats = true;
      vram = true;

      font_file =  "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFont-Light.ttf";
      font_size = 13;
      hud_compact = true;
      hud_no_margin = true;
      offset_x = 3;
      horizontal = true;

      cpu_color = "5A5A5A";
      gpu_color = "5A5A5A";
      ram_color = "5A5A5A";
      vram_color = "5A5A5A";
      text_color = "A0A0A0";
      text_outline_width = 0.1;
      background_alpha = 0;

      toggle_hud_preset = "Super_L+Alt_L+M";
    };
  };
}
