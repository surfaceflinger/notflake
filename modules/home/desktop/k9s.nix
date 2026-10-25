_: {
  programs.k9s = {
    enable = true;
    package = null;

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
