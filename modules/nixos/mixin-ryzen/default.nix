{ inputs, ... }:
{
  imports = [
    "${inputs.nixos-hardware.result}/common/cpu/amd/pstate.nix"
    "${inputs.nixos-hardware.result}/common/cpu/amd/zenpower.nix"
  ];

  boot.kernelModules = [ "kvm-amd" ];
  services.hardware.openrgb.motherboard = "amd";
}
