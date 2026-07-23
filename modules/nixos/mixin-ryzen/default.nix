{
  config,
  inputs,
  nixosModules,
  ...
}:
{
  imports = [
    "${inputs.nixos-hardware.result}/common/cpu/amd/pstate.nix"
    nixosModules.mixin-baremetal
  ];

  boot = {
    extraModulePackages = [ config.boot.kernelPackages.zenergy ];
    kernelModules = [
      "kvm-amd"
      "zenergy"
    ];
  };

  services.hardware.openrgb.motherboard = "amd";
}
