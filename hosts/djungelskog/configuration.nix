{ inputs, nixosModules, ... }:
{
  imports = [
    "${inputs.nixos-hardware.result}/common/pc/ssd"
    "${inputs.nixos-hardware.result}/lenovo/thinkpad/t440p"
    nixosModules.common
    nixosModules.desktop
    nixosModules.laptop
    nixosModules.mixin-bdprochot
    nixosModules.mixin-gaming
    nixosModules.user-nat
    nixosModules.user-natwork
    ./storage.nix
  ];

  # base
  nixpkgs.hostPlatform = "x86_64-linux";

  # bootloader/kernel/modules
  hardware.enableRedistributableFirmware = true;
  boot = {
    loader.limine = {
      biosDevice = "/dev/sda";
      biosSupport = true;
    };
    initrd.availableKernelModules = [
      "ahci"
      "ehci_pci"
      "rtsx_pci_sdmmc"
      "sd_mod"
      "sr_mod"
      "usb_storage"
      "xhci_pci"
    ];
    kernelModules = [ "kvm-intel" ];
  };

  # power management
  boot.kernelParams = [ "intel_pstate=passive" ];

  # make fan silent
  services.zcfan.enable = true;

  # disable these fucking pgup/pgdown around arrow up - who came up with this?
  services.keyd = {
    enable = true;
    keyboards."liteon" = {
      ids = [ "0001:0001" ];
      settings.main = {
        pageup = "noop";
        pagedown = "noop";
      };
    };
  };
}
