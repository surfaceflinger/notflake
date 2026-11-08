{ lib, ... }: {
  # perf-first: thermald is just another thing that throttles, throttled owns the CPU limits
  services.thermald.enable = lib.mkForce false;

  # TLP owns EPP/boost and (where supported) charge thresholds; throttled owns PL1/PL2
  services.tlp.settings = {
    CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
    CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_performance";
  };

  services.throttled = {
    enable = true;
    extraConfig = ''
      [GENERAL]
      Enabled: True
      Sysfs_Power_Path: /sys/class/power_supply/AC*/online
      Autoreload: True

      # stock AC limits: 20 W sustained, 55 W short-term (DPTF would cap boost to 40 W)
      [AC]
      Update_Rate_s: 5
      PL1_Tdp_W: 20
      PL1_Duration_s: 28
      PL2_Tdp_W: 55
      PL2_Duration_S: 0.0024
      cTDP: 0
      Disable_BDPROCHOT: True

      # below the EC's 15/35 battery limits to trade some speed for runtime
      [BATTERY]
      Update_Rate_s: 30
      PL1_Tdp_W: 12
      PL1_Duration_s: 28
      PL2_Tdp_W: 25
      PL2_Duration_S: 0.0024
      cTDP: 0
      Disable_BDPROCHOT: True

      # Raptor Lake-U has a locked voltage interface, offsets are ignored
      [UNDERVOLT.AC]
      CORE: 0
      GPU: 0
      CACHE: 0
      UNCORE: 0
      ANALOGIO: 0

      [UNDERVOLT.BATTERY]
      CORE: 0
      GPU: 0
      CACHE: 0
      UNCORE: 0
      ANALOGIO: 0
    '';
  };
}
