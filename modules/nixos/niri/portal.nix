{ inputs, pkgs, ... }: {
  xdg.portal.extraPortals = with pkgs; [
    inputs.xdg-desktop-portal-gtk4.result.packages.${pkgs.stdenv.hostPlatform.system}.default
    xdg-desktop-portal-gnome
  ];

  xdg.portal.config.niri = {
    default = [ "gtk4" ];
    "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
    "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
    "org.freedesktop.impl.portal.RemoteDesktop" = [ "gnome" ];
    "org.freedesktop.impl.portal.Background" = [ "gnome" ];
    "org.freedesktop.impl.portal.Wallpaper" = [ "gnome" ];
    "org.freedesktop.impl.portal.Settings" = [ "gnome" ];
    "org.freedesktop.impl.portal.Secret" = [ "oo7-portal" ];
  };
}
