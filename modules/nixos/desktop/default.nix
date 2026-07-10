{ inputs, pkgs, ... }: {
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

  #boot.kernelPackages = pkgs.linuxPackages_xanmod;

  time.timeZone = "Europe/Warsaw";
  location.provider = "geoclue2";

  services.kmscon.config = {
    font-name = "Cascadia Mono PL";
    hwaccel = true;
  };

  # fix qt crashes
  environment.extraInit = ''
    export XDG_DATA_DIRS="$XDG_DATA_DIRS:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
  '';
}
