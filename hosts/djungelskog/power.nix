{ lib, ... }: {
  # throttled owns PL1/PL2 and BD PROCHOT; thermald would apply its own RAPL policy
  services.thermald.enable = lib.mkForce false;

  services.throttled = {
    enable = true;
    extraConfig = ''
      [GENERAL]
      Enabled: True
      Sysfs_Power_Path: /sys/class/power_supply/AC*/online
      Autoreload: True

      # firmware limits for this cpu: 47 w / 28 s sustained, 58.75 w short
      [AC]
      Update_Rate_s: 5
      PL1_Tdp_W: 47
      PL1_Duration_s: 28
      PL2_Tdp_W: 58
      PL2_Duration_S: 0.001
      Disable_BDPROCHOT: True

      # intel's ctdp-down point for the i7-4910mq
      [BATTERY]
      Update_Rate_s: 30
      PL1_Tdp_W: 37
      PL1_Duration_s: 28
      PL2_Tdp_W: 47
      PL2_Duration_S: 0.001
      Disable_BDPROCHOT: True
    '';
  };
}
