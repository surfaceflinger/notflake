{ inputs, nixosModules, ... }: {
  imports = [
    "${inputs.nixos-hardware.result}/common/pc/ssd"
    "${inputs.nixos-hardware.result}/lenovo/thinkpad/t440p"
    nixosModules.common
    nixosModules.desktop-env
    nixosModules.laptop
    nixosModules.mixin-bdprochot
    nixosModules.mixin-gaming
    nixosModules.mixin-intel
    nixosModules.user-nat
    ./storage.nix
  ];

  # bootloader/kernel/modules
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
  };

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
