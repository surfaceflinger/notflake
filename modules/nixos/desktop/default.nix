{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    "${inputs.srvos.result}/nixos/desktop"
    ./bluetooth.nix
    ./gnome.nix
    ./logitech.nix
    ./networking.nix
    ./pipewire.nix
    ./printing.nix
    ./system-packages.nix
    ./unharden.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_xanmod;

  # sched-ext
  services.scx = {
    # enable = !pkgs.stdenv.isAarch64;
    enable = lib.warn "scx and metadata-cleaner temporarily disabled" false;
    package = pkgs.scx.rustscheds;
    scheduler = "scx_bpfland";
  };

  time.timeZone = "Europe/Warsaw";
  location.provider = "geoclue2";
}
