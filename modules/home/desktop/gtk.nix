{ config, pkgs, ... }: {
  imports = [ ./dconf.nix ];

  gtk = {
    enable = true;
    gtk3.extraCss = builtins.readFile ./gtk.css;
    gtk4.theme = config.gtk.theme;
    cursorTheme = {
      name = "miku-cursor";
      package = pkgs.miku-cursor;
    };
    iconTheme = {
      name = "MoreWaita";
      package = pkgs.morewaita-icon-theme;
    };
  };
}
