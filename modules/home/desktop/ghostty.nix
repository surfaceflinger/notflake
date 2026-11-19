_: {
  programs.ghostty = {
    enable = true;
    settings = {
      window-decoration = "none";
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
