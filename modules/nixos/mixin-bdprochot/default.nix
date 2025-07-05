{ lib, pkgs, ... }:
{
  hardware.cpu.x86.msr.enable = true;

  systemd.services.bdprochot = {
    description = "Keep BD PROCHOT disabled";

    # Apply MSR values on boot, nixos generation switch and resume
    wantedBy = [
      "multi-user.target"
      "post-resume.target"
    ];
    after = [ "post-resume.target" ];

    serviceConfig = {
      Type = "oneshot";
      Restart = "no";
      ExecStart = lib.getExe pkgs.disable-bd-prochot;
    };
  };

  systemd.timers.bdprochot = {
    description = "BD PROCHOT timer to ensure it's off";
    partOf = [ "bdprochot.service" ];
    wantedBy = [ "multi-user.target" ];
    timerConfig = {
      OnBootSec = "2min";
      OnUnitActiveSec = "10min";
    };
  };
}
