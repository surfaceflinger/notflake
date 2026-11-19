{ pkgs, ... }: {
  imports = [ ./dconf.nix ];

  stylix.targets.gtk.extraCss = "window.background { border-radius: 0; }";

  gtk = {
    iconTheme = {
      name = "MoreWaita";
      package = pkgs.morewaita-icon-theme;
    };
  };
}
