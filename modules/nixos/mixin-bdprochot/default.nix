{ lib, pkgs, ... }: {
  hardware.cpu.x86.msr.enable = true;

  systemd.services.bdprochot = {
    description = "Keep BD PROCHOT disabled";
    after = [
      "hibernate.target"
      "hybrid-sleep.target"
      "suspend.target"
      "suspend-then-hibernate.target"
    ];
    wantedBy = [
      "hibernate.target"
      "hybrid-sleep.target"
      "multi-user.target"
      "suspend.target"
      "suspend-then-hibernate.target"
    ];
    serviceConfig = {
      ExecStart = lib.getExe pkgs.disable-bd-prochot;
      Type = "oneshot";
    };
  };

  systemd.timers.bdprochot = {
    description = "Periodically re-apply BD PROCHOT disable";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnUnitActiveSec = "10min";
      Unit = "bdprochot.service";
    };
  };
}
