{ inputs, ... }:
{
  imports = [ "${inputs.nixos-hardware.result}/common/pc/laptop" ];

  nix-mineral.overrides.performance.no-mitigations = true;

  services.tlp = {
    settings = {
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
    };
  };
  services.thermald.enable = true;

  # personal preference on how logind should handle lid switch.
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "lock";
  };
}
