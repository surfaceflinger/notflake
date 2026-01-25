{ inputs, pkgs, ... }:
{
  imports = [
    "${inputs.srvos.result}/nixos/desktop"
    ./bluetooth.nix
    ./gnome.nix
    ./logitech.nix
    ./mdns.nix
    ./networkmanager.nix
    ./pipewire.nix
    ./printing.nix
    ./system-packages.nix
    ./unharden.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_xanmod_stable;

  time.timeZone = "Europe/Warsaw";
  location.provider = "geoclue2";

  services.kmscon.hwRender = true;
}
