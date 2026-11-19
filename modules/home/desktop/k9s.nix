_: {
  programs.k9s = {
    enable = true;

    # stylix writes settings.ui.skin (which k9s ignores) instead of
    # settings.k9s.ui.skin; point at its theme explicitly until fixed upstream
    settings.k9s.ui.skin = "stylix";
  };
}
