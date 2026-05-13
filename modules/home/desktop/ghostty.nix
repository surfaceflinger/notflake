_: {
  programs.ghostty = {
    enable = true;
    settings = {
      cursor-style = "bar";
      font-family = "Cascadia Mono PL";
      font-size = 11;
      grapheme-width-method = "legacy";
      term = "xterm-256color";
      theme = "light:mylight,dark:mydark";
      window-padding-x = 4;
      window-padding-y = 4;
      window-theme = "ghostty";
    };

    themes.mydark = {
      background = "#1f1822";
      cursor-color = "#f0a7d8";
      cursor-text = "#1f1822";
      foreground = "#f0d8e8";
      selection-background = "#7e4f78";
      selection-foreground = "#f0d8e8";
      palette = [
        "0=#241f31"
        "1=#ff2e63"
        "2=#5fd9a1"
        "3=#f5a97f"
        "4=#8aa0e8"
        "5=#f0a7d8"
        "6=#c6a0f6"
        "7=#c0bfbc"
        "8=#5e5c64"
        "9=#ff5577"
        "10=#88e8b8"
        "11=#ffc090"
        "12=#a5b8f0"
        "13=#ffafe8"
        "14=#d8baff"
        "15=#f6f5f4"
      ];
    };

    themes.mylight = {
      background = "#fdf2f8";
      cursor-color = "#c04ba6";
      cursor-text = "#fdf2f8";
      foreground = "#3d1a3d";
      selection-background = "#d4a0bf";
      selection-foreground = "#3d1a3d";
      palette = [
        "0=#241f31"
        "1=#c41e3a"
        "2=#3a9a73"
        "3=#c97550"
        "4=#5c6fc0"
        "5=#c04ba6"
        "6=#8762d4"
        "7=#7e6679"
        "8=#5e5c64"
        "9=#e6294b"
        "10=#2d8a64"
        "11=#a85e34"
        "12=#6c80cf"
        "13=#d168b5"
        "14=#9a76dc"
        "15=#3d1a3d"
      ];
    };
  };
}
