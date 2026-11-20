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
    package = inputs.niri.result.packages.${pkgs.stdenv.hostPlatform.system}.niri;

    settings = {
      includes = [
        {
          # niri-flake's settings can't render allow-tearing; a derivation path
          # also needs the string coercion or kdl prints it as a typed value
          path = "${pkgs.writeText "niri-tearing.kdl" ''
            window-rule {
                match app-id=r#"^steam_app_"#
                allow-tearing true
            }
            window-rule {
                match app-id=r#"^java$"#
                allow-tearing true
            }
          ''}";
        }
      ];

      input = {
        keyboard.xkb.layout = "pl";
        touchpad = {
          tap = true;
          natural-scroll = false;
        };
        mouse.accel-profile = "flat";

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

      window-rules = [
        {
          # niri otherwise paints a solid border-coloured rect behind every
          # CSD window, which hides translucency and makes blur sample a
          # flat fill
          draw-border-with-background = false;
        }
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
          default-window-height.proportion = 0.6;
        }
        {
          matches = [ { app-id = "^com\\.chmouel\\.raffi$"; } ];
          open-floating = true;
          default-column-width.proportion = 0.45;
          default-window-height.proportion = 0.78;
          background-effect = {
            blur = true;
            xray = false;
          };
        }
        {
          matches = [ { app-id = "^com\\.mitchellh\\.ghostty$"; } ];
          background-effect = {
            blur = true;
            xray = true;
          };
        }
      ];

      layer-rules = [
        {
          matches = [ { namespace = "^ashell-"; } ];
          background-effect.blur = true;
        }
      ];

      workspaces = {
        "1" = { };
        "2" = { };
        "3" = { };
        "4" = { };
      };

      spawn-at-startup = [ { argv = [ "ashell" ]; } ];
    };
  };

  home.packages = [
    niriFlake.packages.${pkgs.stdenv.hostPlatform.system}.xwayland-satellite-unstable
  ];
}
