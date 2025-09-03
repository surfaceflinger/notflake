{ inputs, pkgs, ... }:
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

  time.timeZone = "Europe/Warsaw";
  location.provider = "geoclue2";
}
