{ pkgs, ... }: {
  nixpkgs.overlays = [
    (final: prev: {
      mutter = prev.mutter.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          (prev.fetchurl {
            url = "https://raw.githubusercontent.com/CachyOS/CachyOS-PKGBUILDS/d77349cf2d8d0b39b40c029474fbb98315085001/mutter/Add-support-for-tearing.patch";
            hash = "sha256-oi4KjBJMDP5NUONDslYElXvUUxUSloyzn6QTTH01DqI=";
          })
          ./mutter-xdg-toplevel-icon.patch
        ];
      });

      gnome-shell = (prev.gnome-shell.override { inherit (final) mutter; }).overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ ./gnome-shell-window-icon.patch ];
      });
    })
  ];

  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
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

  environment.systemPackages = with pkgs; [
    gnome-session
    refine
    # fetch gravatar and install as ~/.face
    gnome-gravatar
    # the way weather works in gnome is terrible :(
    gnome-weather-set
  ];
}
