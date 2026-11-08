{ pkgs, ... }:
{
  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style = {
      name = "libAdwaita";
      package = [
        pkgs.libadwaita-qt
        (pkgs.libadwaita-qt.override { useQt6 = false; })
      ];
    };
  };

  home.packages = with pkgs; [
    qadwaitadecorations
    qadwaitadecorations-qt6
  ];

  home.sessionVariables.QT_WAYLAND_DECORATION = "adwaita";
  systemd.user.sessionVariables.QT_WAYLAND_DECORATION = "adwaita";
}
