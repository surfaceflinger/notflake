{ lib, pkgs, ... }: {
  home.packages = [ pkgs."redland-wayland" ];

  systemd.user.services.redland = {
    Unit = {
      Description = "Screen color temperature (night light)";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };

    Install.WantedBy = [ "graphical-session.target" ];

    Service = {
      # below ~3000k video looks orange, above ~4000k melatonin suppression
      # barely drops
      ExecStart = "${lib.getExe pkgs."redland-wayland"} --lat 52.2297 --lon 21.0122 --low 3500";
      Restart = "on-failure";
    };
  };
}
