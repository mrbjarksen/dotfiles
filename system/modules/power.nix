{ config, lib, pkgs, ... }:

{
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=2h
    SuspendEstimationSec=120s
  '';

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "suspend-then-hibernate";
    HandlePowerKey = "suspend-then-hibernate";
    HandlePowerKeyLongPress = "poweroff";
  };
}
