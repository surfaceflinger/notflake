_: {
  programs.niri.settings = {
    # framework 12 touchscreen
    input.touch.map-to-output = "eDP-1";

    outputs."eDP-1".variable-refresh-rate = "on-demand";
  };
}
