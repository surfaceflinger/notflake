{ inputs, ... }:
{
  imports = [ "${inputs.nixos-hardware.result}/common/pc/laptop" ];

  nix-mineral.overrides.performance.no-mitigations = true;

  # personal preference on how logind should handle lid switch.
  services.logind.settings.Login = {
    HandleLidSwitchDocked = "ignore";
    HandleLidSwitchExternalPower = "lock";
    HandleLidSwitch = "suspend";
  };
}
