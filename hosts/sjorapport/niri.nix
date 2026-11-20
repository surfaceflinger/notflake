_: {
  programs.niri.settings = {
    # framework 12 touchscreen
    input.touch.map-to-output = "eDP-1";

    outputs."eDP-1" = {
      scale = 1.0;
      variable-refresh-rate = "on-demand";
    };
  };
}
