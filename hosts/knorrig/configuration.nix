{ inputs, nixosModules, ... }:
{
  imports = [
    "${inputs.nixos-hardware.result}/common/gpu/amd"
    "${inputs.nixos-hardware.result}/common/pc/ssd"
    nixosModules.common
    nixosModules.desktop
    nixosModules.laptop
    nixosModules.mixin-gaming
    nixosModules.mixin-ryzen
    nixosModules.mixin-tpm20
    nixosModules.mixin-virtualisation
    nixosModules.user-nat
    nixosModules.user-natwork
    ./storage.nix
  ];

  # base
  nixpkgs.hostPlatform = "x86_64-linux";

  # bootloader/kernel/modules
  hardware.enableRedistributableFirmware = true;
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "usb_storage"
    "sd_mod"
  ];
}
