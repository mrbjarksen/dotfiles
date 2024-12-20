{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ brightnessctl ];
  services.acpid = {
    enable = true;
    handlers = let
      brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
      wpctl = "${pkgs.wireplumber}/bin/wireplumber";
    in {
      brightness-up =   { event = "video/brightnessup.*"; action = "${brightnessctl} --exponent=2 set 5%+"; };
      brightness-down = { event = "video/brightnessup.*"; action = "${brightnessctl} --exponent=2 set 5%-"; };

      volumeup =   { event = "button/volumeup.*";   action = "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%+";    };
      volumedowm = { event = "button/volumedown.*"; action = "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-";    };
      mute =       { event = "button/mute.*";       action = "${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";   };
      mic-mute =   { event = "button/micmute.*";    action = "${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; };
    };
  };
}
