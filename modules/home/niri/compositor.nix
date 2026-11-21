{ inputs, pkgs, ... }:
let
  niriFlake = inputs.niri-flake.result;
in
{
  imports = [
    niriFlake.homeModules.config
    niriFlake.homeModules.stylix
  ];

  programs.niri = {
    package = inputs.niri.result.packages.${pkgs.stdenv.hostPlatform.system}.niri;

    settings = {
      includes = [
        {
          # niri-flake can't render allow-tearing or fullscreen-only VRR; a
          # derivation path also needs the string coercion or kdl prints it
          # as a typed value
          path = "${pkgs.writeText "niri-window-rules.kdl" ''
            window-rule {
                match app-id=r#"^steam_app_"#
                allow-tearing true
            }
            window-rule {
                match app-id=r#"^java$"#
                allow-tearing true
            }
            window-rule {
                variable-refresh-rate "fullscreen-only"
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
      screenshot.path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
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
          matches = [
            {
              app-id = "^org\\.telegram\\.desktop$";
              title = "^Media viewer$";
            }
          ];
          open-floating = true;
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
          matches = [
            {
              app-id = "^steam$";
              title = "^notificationtoasts_[0-9]+_desktop$";
            }
          ];
          open-floating = true;
          open-focused = false;
          default-floating-position = {
            x = 10;
            y = 10;
            relative-to = "bottom-right";
          };
        }
        {
          matches = [
            { app-id = "^hyprpolkitagent$"; }
            { app-id = "^xdg-desktop-portal-gtk4$"; }
            { title = "^(Open File|Save File|Save As|Open Folder|File Upload|Authentication Required)$"; }
          ];
          open-floating = true;
        }
        {
          matches = [
            {
              app-id = "^(Schizofox|firefox)$";
              title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$";
            }
          ];
          open-floating = true;
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
        {
          matches = [ { is-floating = true; } ];
          background-effect.xray = false;
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
