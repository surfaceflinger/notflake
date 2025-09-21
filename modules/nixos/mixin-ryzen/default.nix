{ inputs, ... }:
{
  imports = [
    "${inputs.nixos-hardware.result}/common/cpu/amd/pstate.nix"
  ];

  boot = {
    blacklistedKernelModules = [ "k10temp" ];
    extraModulePackages = [ config.boot.kernelPackages.zenergy ];
    kernelModules = [ "kvm-amd" "zenergy" ];
  };

  services.hardware.openrgb.motherboard = "amd";
}
