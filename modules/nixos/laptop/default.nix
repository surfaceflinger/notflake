{ inputs, ... }: {
  imports = [ "${inputs.nixos-hardware.result}/common/pc/laptop" ];

  # personal preference on how logind should handle lid switch.
  services.logind.settings.Login = {
    HandleLidSwitchDocked = "ignore";
    HandleLidSwitchExternalPower = "lock";
    HandleLidSwitch = "suspend";
  };

  # power management
  services.tlp = {
    enable = true;
    pd.enable = true;
    settings = {
      # bat thresholds
      START_CHARGE_THRESH_BAT0 = 85;
      START_CHARGE_THRESH_BAT1 = 85;
      STOP_CHARGE_THRESH_BAT0 = 90;
      STOP_CHARGE_THRESH_BAT1 = 90;
      # kernel defaults are ok, some platforms support only s0ix
      MEM_SLEEP_ON_AC = "";
      MEM_SLEEP_ON_BAT = "";
      MEM_SLEEP_ON_SAV = "";
      # disable turbo on powersaver
      CPU_HWP_DYN_BOOST_ON_SAV = 0;
      CPU_BOOST_ON_SAV = 0;
    };
  };
}
