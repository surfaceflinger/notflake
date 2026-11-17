{ pkgs, ... }: {
  imports = [ ./dconf.nix ];

  programs.gnome-shell = {
    enable = true;
    extensions = with pkgs.gnomeExtensions; [
      { package = appindicator; }
      { package = auto-move-windows; }
      { package = media-progress; }
      { package = pip-on-top; }
      { package = user-themes-x; }
      { package = window-is-ready-remover; }
    ];
  };
}
