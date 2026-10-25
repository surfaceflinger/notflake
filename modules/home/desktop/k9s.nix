{ pkgs, ... }:
let
  k9s = pkgs.k9s.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      (pkgs.writeText "k9s-ansi.patch" (
        builtins.concatStringsSep "\n" [
          "--- a/internal/config/color.go"
          "+++ b/internal/config/color.go"
          "@@ -56,12 +56,11 @@"
          " \tif c == DefaultColor {"
          " \t\treturn \"-\""
          " \t}"
          "-\tcol := c.Color().TrueColor().Hex()"
          "-\tif col < 0 {"
          "+\tif c.Color() == tcell.ColorDefault {"
          " \t\treturn \"-\""
          " \t}"
          " "
          "-\treturn fmt.Sprintf(\"#%06x\", col)"
          "+\treturn string(c)"
          " }"
          " "
          " func (c Color) isHex() bool {"
          "@@ -74,7 +73,7 @@"
          " \t\treturn tcell.ColorDefault"
          " \t}"
          " "
          "-\treturn tcell.GetColor(string(c)).TrueColor()"
          "+\treturn tcell.GetColor(string(c))"
          " }"
          " "
          " // maxChromaForLH finds the maximum chroma at a given lightness and hue"
          ""
        ]
      ))
    ];
    # tests assert the old truecolor values
    doCheck = false;
  });
in
{
  programs.k9s = {
    enable = true;
    package = k9s;

    settings.k9s.ui.skin = "ansi";

    skins.ansi.k9s = {
      body = {
        fgColor = "white";
        bgColor = "default";
        logoColor = "fuchsia";
      };
      prompt = {
        fgColor = "aqua";
        bgColor = "default";
        suggestColor = "blue";
      };
      info = {
        fgColor = "yellow";
        sectionColor = "white";
      };
      dialog = {
        fgColor = "white";
        bgColor = "default";
        buttonFgColor = "black";
        buttonBgColor = "aqua";
        buttonFocusFgColor = "black";
        buttonFocusBgColor = "white";
        labelFgColor = "yellow";
        fieldFgColor = "aqua";
      };
      frame = {
        border = {
          fgColor = "blue";
          focusColor = "aqua";
        };
        menu = {
          fgColor = "white";
          fgStyle = "dim";
          keyColor = "aqua";
          numKeyColor = "fuchsia";
        };
        crumbs = {
          fgColor = "black";
          bgColor = "blue";
          activeColor = "yellow";
        };
        status = {
          newColor = "aqua";
          modifyColor = "yellow";
          addColor = "green";
          errorColor = "red";
          pendingColor = "yellow";
          highlightColor = "aqua";
          killColor = "fuchsia";
          completedColor = "gray";
        };
        title = {
          fgColor = "aqua";
          highlightColor = "fuchsia";
          counterColor = "white";
          filterColor = "blue";
        };
      };
      views = {
        charts = {
          bgColor = "default";
          defaultDialColors = [
            "green"
            "red"
          ];
          defaultChartColors = [
            "green"
            "red"
          ];
        };
        table = {
          fgColor = "white";
          bgColor = "default";
          cursorFgColor = "black";
          cursorBgColor = "aqua";
          markColor = "yellow";
          header = {
            fgColor = "white";
            bgColor = "default";
            sorterColor = "yellow";
          };
        };
        xray = {
          fgColor = "white";
          bgColor = "default";
          cursorColor = "aqua";
          graphicColor = "yellow";
          showIcons = false;
        };
        yaml = {
          keyColor = "blue";
          colonColor = "white";
          valueColor = "white";
        };
        logs = {
          fgColor = "white";
          bgColor = "default";
          indicator = {
            fgColor = "aqua";
            bgColor = "default";
            toggleOnColor = "green";
            toggleOffColor = "blue";
          };
        };
      };
    };
  };
}
