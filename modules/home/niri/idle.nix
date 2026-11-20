{ lib, pkgs, ... }:
let
  lock = lib.getExe pkgs.hyprlock;

  lockAndBlank = pkgs.writeShellScript "idle-lock" ''
    niri msg action power-off-monitors
    exec ${lock}
  '';

  lockCmd = "${lib.getExe' pkgs.procps "pidof"} hyprlock || ${lockAndBlank}";
in
{
  services.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = lockCmd;
        before_sleep_cmd = lockCmd;
      };

      listener = [
        {
          timeout = 30;
          on-timeout = "${lib.getExe' pkgs.procps "pidof"} hyprlock && niri msg action power-off-monitors";
        }
        {
          timeout = 180;
          on-timeout = "${lockAndBlank}";
        }
        {
          timeout = 300;
          on-timeout = "${pkgs.writeShellScript "idle-suspend-battery" ''
            for status in /sys/class/power_supply/BAT*/status; do
              [ -r "$status" ] || continue
              if [ "$(cat "$status")" = "Discharging" ]; then
                exec ${lib.getExe' pkgs.systemd "systemctl"} suspend
              fi
            done
          ''}";
        }
        {
          timeout = 1200;
          on-timeout = "${pkgs.writeShellScript "idle-suspend" ''
            for online in /sys/class/power_supply/*/online; do
              [ -r "$online" ] || continue
              if [ "$(cat "$online")" = "1" ]; then
                exec ${lib.getExe' pkgs.systemd "systemctl"} suspend
              fi
            done
          ''}";
        }
      ];
    };
  };
}
