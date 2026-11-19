{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  niriFlake = inputs.niri-flake.result;
in
{
  imports = [ niriFlake.homeModules.config ];

  programs.niri = {
    package = niriFlake.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable;

    settings = {
      input = {
        keyboard.xkb.layout = "pl";
        touchpad = {
          tap = true;
          natural-scroll = false;
        };
        mouse.accel-profile = "flat";

        # framework 12 touchscreen
        touch.map-to-output = "eDP-1";

        # the power key goes to logind, see desktop-env
        power-key-handling.enable = false;
      };

      hotkey-overlay.skip-at-startup = true;
      gestures.hot-corners = {
        top-left = true;
        top-right = false;
        bottom-left = false;
        bottom-right = false;
      };

      outputs =
        lib.genAttrs
          [
            "eDP-1"
            "eDP-2"
            "HDMI-A-1"
            "HDMI-A-2"
            "DP-1"
            "DP-2"
            "DP-3"
            "DP-4"
            "DVI-I-1"
            "Virtual-1"
          ]
          (_: {
            scale = 1;
            variable-refresh-rate = true;
          });

      window-rules = [
        {
          matches = [ { app-id = "^(bitwarden|org\\.telegram\\.desktop|vesktop)$"; } ];
          open-on-workspace = "1";
        }
        {
          matches = [ { app-id = "^(Schizofox|firefox)$"; } ];
          open-on-workspace = "2";
        }
        {
          matches = [ { app-id = "^(lunarclient|org\\.prismlauncher\\.PrismLauncher|slack)$"; } ];
          open-on-workspace = "3";
        }
        {
          matches = [ { app-id = "^steam$"; } ];
          open-on-workspace = "4";
        }
        {
          matches = [ { app-id = "^ashell-tui$"; } ];
          open-floating = true;
          default-column-width.proportion = 0.7;
          default-window-height.fixed = 650;
        }
        {
          matches = [ { app-id = "^com\\.chmouel\\.raffi$"; } ];
          open-floating = true;
          default-column-width.proportion = 0.45;
          default-window-height.proportion = 0.78;
        }
      ];

      spawn-at-startup = [ { argv = [ "ashell" ]; } ];
    };
  };

  home.packages = [
    niriFlake.packages.${pkgs.stdenv.hostPlatform.system}.xwayland-satellite-unstable
  ];
}
