{
  config,
  inputs,
  nixosModules,
  ...
}:
{
  imports = [
    "${inputs.nixos-hardware.result}/common/cpu/intel/haswell"
    "${inputs.nixos-hardware.result}/common/gpu/amd"
    "${inputs.nixos-hardware.result}/common/pc"
    "${inputs.nixos-hardware.result}/common/pc/ssd"
    inputs.xkomhotshot.result.nixosModules.default
    ../../modules/nixos/desktop/mdns.nix
    ./monero.nix
    nixosModules.common
    nixosModules.mixin-intel
    nixosModules.mixin-telemetry
    nixosModules.mixin-virtualisation
    nixosModules.mixin-www
    nixosModules.server
    nixosModules.user-nat
    ./observability
    ./storage.nix
  ];

  # bootloader/kernel/modules
  boot = {
    loader.limine = {
      biosDevice = "/dev/sda";
      biosSupport = true;
      partitionIndex = 2;
    };
    initrd.availableKernelModules = [
      "ahci"
      "ehci_pci"
      "sd_mod"
      "sr_mod"
      "usbhid"
      "usb_storage"
      "xhci_pci"
    ];
  };

  # this is an old intel and the other mode sucks
  boot.kernelParams = [ "intel_pstate=passive" ];

  # xkom telegram bot
  age.secrets.xkomhotshot.file = ../../secrets/xkomhotshot.age;
  services.xkomhotshot = {
    enable = true;
    environmentFile = config.age.secrets.xkomhotshot.path;
  };

  # reverse proxy my printer so its accessible over tailscale
  # if needed:
  # lpadmin -p biblioteka -E -v ipp://skogsduva:631/ipp -m everywhere
  services.caddy.virtualHosts.":631".extraConfig = ''
    reverse_proxy BRN3C2AF400C594.lan:631
  '';

  # tor snowflake proxy
  services.snowflake-proxy.enable = true;

  # fix building
  nix-mineral.overrides.desktop.allow-multilib = true;
}
