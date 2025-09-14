{ pkgs, ... }:
{
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
    # qt gnome styling
    QT_WAYLAND_DECORATION = "adwaita";
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
    gnome-system-monitor
    gnome-tour
    gnome-user-docs
    orca
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
    gnome-tweaks

    # theming
    adw-gtk3
    morewaita-icon-theme
    qadwaitadecorations
    qadwaitadecorations-qt6

    # fetch gravatar and install as ~/.face
    gnome-gravatar

    # the way weather works in gnome is terrible :(
    gnome-weather-set
  ];

  fonts = {
    fontconfig.cache32Bit = true;
    packages = with pkgs; [
      atkinson-hyperlegible-next
      brill
      cascadia-code
    ];
  };

  programs.gamemode.enable = true;
  services = {
    power-profiles-daemon.enable = false;
    tlp.enable = false;
    tuned.enable = true;
  };
}
