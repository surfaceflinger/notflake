{ ... }:
{
  # the g52a flickers at its preferred 165hz, see the video= kernel param
  programs.niri.settings.outputs."DP-2" = {
    mode = {
      width = 2560;
      height = 1440;
      refresh = 144.0;
    };
    variable-refresh-rate = true;
  };
}
