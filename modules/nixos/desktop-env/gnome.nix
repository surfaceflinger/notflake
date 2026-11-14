{ pkgs, ... }: {
  nixpkgs.overlays = [
    (final: prev: {
      mutter = prev.mutter.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          (prev.fetchurl {
            url = "https://raw.githubusercontent.com/CachyOS/CachyOS-PKGBUILDS/1fe3a99366801e90362b4995f5d3d0d48dad9d8e/mutter/Add-support-for-tearing.patch";
            hash = "sha256-Fh5DG6fJTpAS/Y5KxnXo6Y13MC4Qe/nCzCnD2Rwx9Sc=";
          })
          ./mutter-xdg-toplevel-icon.patch
        ];
      });

      gnome-shell = (prev.gnome-shell.override { mutter = final.mutter; }).overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ ./gnome-shell-window-icon.patch ];
      });
    })
  ];

  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  environment.sessionVariables = {
    # nicer font rendering
    FREETYPE_PROPERTIES = "autofitter:no-stem-darkening=0 autofitter:darkening-parameters=500,0,1000,500,2500,500,4000,0 cff:no-stem-darkening=0 type1:no-stem-darkening=0 t1cid:no-stem-darkening=0";
    QT_NO_SYNTHESIZED_BOLD = 1;
    # wayland in (most) electron apps
    NIXOS_OZONE_WL = "1";
  };

  # debloat
  environment.gnome.excludePackages = with pkgs; [
    baobab
    decibels
    epiphany
    evince
    gnome-clocks
    gnome-console
    gnome-disk-utility
    gnome-logs
    gnome-maps
    gnome-music
    gnome-software
    gnome-system-monitor
    gnome-tour
    gnome-user-docs
    orca
    showtime
    snapshot
    sushi
    totem
    yelp
  ];

  # other software
  environment.systemPackages = with pkgs; [
    # gnome
    ffmpegthumbnailer
    gnome-session
    refine

    # theming
    adw-gtk3
    morewaita-icon-theme

    # fetch gravatar and install as ~/.face
    gnome-gravatar

    # the way weather works in gnome is terrible :(
    gnome-weather-set
  ];

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

  services.power-profiles-daemon.enable = false;

  # the system-wide speech-dispatcher pulls every synthesizer and mbrola voice
  # (~700 MiB); apps that need it bring their own minimal copy
  services.speechd.enable = false;
}
