{ config, lib, pkgs, ... }:

{
  systemd.user.timers."sol" = {
    Timer = {
      OnCalendar = "Mon..Fri 06:30";
      WakeSystem = true;
      Unit = "sol.service";
    };
    Install.WantedBy = [ "timers.target" ];
  };

  systemd.user.services."sol" = {
    Service = {
      Type = "oneshot";
      ExecStart = toString (pkgs.writeShellScript "sol-wrapper.sh" ''
        export LD_LIBRARY_PATH=${pkgs.wayland}/lib:${pkgs.libxkbcommon}/lib:${pkgs.libGL}/lib
        /home/mrbjarksen/projects/sol/zig-out/bin/sol
      '');
    };
    Unit.After = [ "graphical-session.target" ];
    Install.WantedBy = [ "default.target" ];
  };
}
