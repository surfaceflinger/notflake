{
  config,
  nixosModules,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    "${inputs.nixos-hardware.result}/common/gpu/amd"
    "${inputs.nixos-hardware.result}/common/pc"
    "${inputs.nixos-hardware.result}/common/pc/ssd"
    ./audio.nix
    ./media.nix
    nixosModules.common
    nixosModules.desktop
    nixosModules.mixin-gaming
    nixosModules.mixin-ryzen
    nixosModules.mixin-telemetry
    nixosModules.mixin-tpm20
    nixosModules.mixin-virtualisation
    nixosModules.mixin-www
    nixosModules.user-nat
    ./storage.nix
  ];

  # base
  nixpkgs.hostPlatform = "x86_64-linux";

  # bootloader/kernel/modules
  hardware.enableRedistributableFirmware = true;
  boot = {
    blacklistedKernelModules = [ "uvcvideo" ];
    initrd.availableKernelModules = [
      "ahci"
      "nvme"
      "sd_mod"
      "usbhid"
      "xhci_pci"
    ];
  };

  # disable wifi powersaving
  boot.extraModprobeConfig = ''
    options iwlmvm  power_scheme=1
    options iwlwifi power_save=0
  '';

  # need this for correct gpu work (capped at 220w tdp but it can use 280w)
  # also undervolt
  hardware.amdgpu.overdrive.enable = true;
  services.lact.enable = true;

  # rx7800xt is still pretty much fucked in latest mainline and default 165hz is flickering
  boot.kernelParams = [ "video=2560x1440@144" ];

  # openrgb
  services.hardware.openrgb.enable = true;

  # ollama
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    rocmOverrideGfx = "11.0.0";
  };

  # harmonia binary cache
  networking.firewall.allowedTCPPorts = [ 30909 ];
  services.harmonia = {
    enable = true;
    settings = {
      bind = "[::1]:30908";
    };
  };
  services.caddy.virtualHosts.":30909".extraConfig = ''
    encode zstd gzip {
      match {
        header Content-Type application/x-nix-archive
      }
    }
    reverse_proxy ${config.services.harmonia.settings.bind}
  '';

  # obs with gstreamer and vkcapture; gpu-screen-recorder
  programs.gpu-screen-recorder.enable = true;
  environment.systemPackages = with pkgs; [
    (wrapOBS {
      plugins = with obs-studio-plugins; [
        obs-vaapi
        obs-vkcapture
      ];
    })
    alpaca
    gpu-screen-recorder-gtk
    obs-studio-plugins.obs-vkcapture
  ];

  # tgexpiry
  home-manager.users.nat =
    { ... }:
    {
      imports = [ inputs.tgexpiry.result.homeModules.tgexpiry ];

      services.tgexpiry.enable = true;
    };
}
