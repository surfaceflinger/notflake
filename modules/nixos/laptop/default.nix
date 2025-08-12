{ inputs, ... }:
{
  imports = [ "${inputs.nixos-hardware.result}/common/pc/laptop" ];

  nix-mineral.overrides.performance.no-mitigations = true;

  # personal preference on how logind should handle lid switch.
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "lock";
  };
}
