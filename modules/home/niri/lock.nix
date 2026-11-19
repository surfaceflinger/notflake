_: {
  programs.hyprlock = {
    enable = true;

    settings = {
      general.hide_cursor = true;

      input-field = {
        size = "200, 50";
        fade_on_empty = false;
        outline_thickness = 2;
      };
    };
  };
}
