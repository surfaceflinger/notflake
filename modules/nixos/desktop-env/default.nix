{ inputs, pkgs, ... }: {
  imports = [
    "${inputs.srvos.result}/nixos/desktop"
    ../gnome
    ./bluetooth.nix
    ./mdns.nix
    ./networkmanager.nix
    ./pipewire.nix
    ./printing.nix
    ./system-packages.nix
    ./unharden.nix
  ];

  time.timeZone = "Europe/Warsaw";
  location.provider = "geoclue2";

  environment.sessionVariables = {
    # nicer font rendering
    FREETYPE_PROPERTIES = "autofitter:no-stem-darkening=0 autofitter:darkening-parameters=500,0,1000,500,2500,500,4000,0 cff:no-stem-darkening=0 type1:no-stem-darkening=0 t1cid:no-stem-darkening=0";
    QT_NO_SYNTHESIZED_BOLD = 1;
    # wayland in (most) electron apps
    NIXOS_OZONE_WL = "1";
  };

  fonts = {
    fontconfig.cache32Bit = true;
    packages = with pkgs; [
      atkinson-hyperlegible-next
      cascadia-code
      corefonts
      lora
      vista-fonts
    ];
  };

  # graphical-desktop enables speechd for every desktop, but the system-wide
  # dispatcher pulls every synthesizer and mbrola voice (~700 MiB)
  services.speechd.enable = false;
  # power management is tlp/tuned's job
  services.power-profiles-daemon.enable = false;

  services.kmscon.config = {
    font-name = "Cascadia Mono PL";
    hwaccel = true;
  };

  # fix qt crashes
  environment.extraInit = ''
    export XDG_DATA_DIRS="$XDG_DATA_DIRS:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
  '';
}
