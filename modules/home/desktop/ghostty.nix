_: {
  programs.ghostty = {
    enable = true;
    settings = {
      cursor-style = "bar";
      font-family = "Cascadia Mono PL";
      font-size = 11;
      grapheme-width-method = "legacy";
      term = "xterm-256color";
      theme = "adwaitadark";
      window-padding-x = 4;
      window-padding-y = 4;
      window-theme = "ghostty";
    };

    themes.adwaitadark = {
      background = "#1e1e1e";
      cursor-color = "#ffffff";
      selection-background = "#ffffff";
      selection-foreground = "#5e5c64";
      palette = [
        "0=#241f31"
        "10=#57e389"
        "11=#f8e45c"
        "12=#51a1ff"
        "13=#c061cb"
        "14=#4fd2fd"
        "15=#f6f5f4"
        "1=#c01c28"
        "2=#2ec27e"
        "3=#f5c211"
        "4=#1e78e4"
        "5=#9841bb"
        "6=#0ab9dc"
        "7=#c0bfbc"
        "8=#5e5c64"
        "9=#ed333b"
      ];
    };
  };
}
