{ pkgs, ... }: {
  imports = [ ./dconf.nix ];

  stylix.targets.gtk.extraCss = "window, window.background, window.csd { border-radius: 0; }";

  gtk = {
    iconTheme = {
      name = "MoreWaita";
      package = pkgs.morewaita-icon-theme;
    };
  };
}
