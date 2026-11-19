_: {
  programs.ghostty = {
    enable = true;
    settings = {
      gtk-titlebar = false;
      background-blur = true;
      cursor-style = "bar";
      grapheme-width-method = "legacy";
      term = "xterm-256color";
      window-padding-x = 4;
      window-padding-y = 4;
      window-theme = "ghostty";
    };
  };
}
