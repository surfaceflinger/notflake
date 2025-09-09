{ inputs, nixosModules, ... }:
{
  imports = [
    "${inputs.nixos-hardware.result}/framework/12-inch/13th-gen-intel"
    nixosModules.common
    nixosModules.desktop
    nixosModules.laptop
    nixosModules.mixin-gaming
    nixosModules.mixin-tpm20
    nixosModules.mixin-virtualisation
    nixosModules.user-nat
    ./storage.nix
  ];

  # base
  nixpkgs.hostPlatform = "x86_64-linux";

  # bootloader/kernel/modules
  hardware.enableRedistributableFirmware = true;
  boot = {
    kernelModules = [ "kvm-intel" ];
    initrd = {
      kernelModules = [ "intel_pmc_core" ];
      availableKernelModules = [
        "nvme"
        "sd_mod"
        "usb_storage"
        "xhci_pci"
      ];
    };
  };

  # enable xe driver
  hardware.intelgpu.driver = "xe";
  boot.kernelParams = [
    "i915.force_probe=!a721"
    "xe.force_probe=a721"
  ];
}
