{
  pkgs,
  ...
}:
{
  imports = [ ./dconf.nix ];

  gtk = {
    enable = true;
    gtk3.extraCss = builtins.readFile ./gtk.css;
    cursorTheme = {
      name = "miku-cursor";
      package = pkgs.miku-cursor;
    };
    iconTheme = {
      name = "MoreWaita";
      package = pkgs.morewaita-icon-theme;
    };
  };

  programs.gnome-shell = {
    enable = true;
    extensions = with pkgs.gnomeExtensions; [
      { package = appindicator; }
      { package = auto-move-windows; }
      { package = gamemode-shell-extension; }
      { package = luminus-desktop; }
      { package = media-progress; }
      { package = pip-on-top; }
      { package = tailscale-qs; }
      { package = user-themes-x; }
      { package = window-is-ready-remover; }
    ];
  };
}
