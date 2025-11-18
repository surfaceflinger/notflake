{ inputs, nixosModules, ... }:
{
  imports = [
    "${inputs.nixos-hardware.result}/framework/12-inch/13th-gen-intel"
    nixosModules.common
    nixosModules.desktop
    nixosModules.laptop
    nixosModules.mixin-gaming
    nixosModules.mixin-intel
    nixosModules.mixin-tpm20
    nixosModules.mixin-virtualisation
    nixosModules.user-nat
    ./storage.nix
  ];

  # bootloader/kernel/modules
  boot.initrd = {
    kernelModules = [ "intel_pmc_core" ];
    availableKernelModules = [
      "nvme"
      "sd_mod"
      "usb_storage"
      "xhci_pci"
    ];
  };

  # enable xe driver
  hardware.intelgpu.driver = "xe";
  boot.kernelParams = [
    "i915.force_probe=!a721"
    "xe.force_probe=a721"
  ];

  # i need angry birds and subway surfers
  virtualisation.waydroid.enable = true;
}
