let
  pins = import ./npins;

  nilla = import pins.nilla;
in
nilla.create (
  { config }: {
    includes = [ "${pins.nilla-utils}/modules" ];

    config = {
      generators.inputs.pins = pins;
      inputs =
        let
          # these flake inputs just need their own nixpkgs input swapped for ours
          nixpkgsOverrides =
            [
              "atk-info"
              "autoaspm"
              "claude-code-nix"
              "copyparty"
              "home-manager"
              "nix-index-database"
              "nix-mineral"
              "tgexpiry"
              "xkomhotshot"
            ]
            |> map (name: {
              inherit name;
              value.settings.inputs.nixpkgs = config.inputs.nixpkgs-flake.result;
            })
            |> builtins.listToAttrs;

          # these are nilla projects rather than flakes, so their nixpkgs input
          # is overridden by extending them with a module instead; the src is
          # already set by their own nilla.nix, so force our value to win
          forceOurNixpkgs.settings.extend.modules = [
            ({ lib, ... }: {
              config.inputs.nixpkgs.src = config.inputs.nixpkgs.src |> lib.modules.overrides.force;
            })
          ];
        in
        {
          nixpkgs.settings = {
            configuration.allowUnfree = true;
            overlays = [ config.overlays.default ];
          };

          # we need nixpkgs loaded as a flake to use it for overriding nixpkgs inputs
          nixpkgs-flake = {
            inherit (config.inputs.nixpkgs) src;
            loader = "flake";
          };

          # these inputs offer only nixos modules so
          # we can just import relevant default.nix files
          agenix.loader = "raw";
          nixos-hardware.loader = "raw";
          srvos.loader = "raw";

          # these also vendor their own copy of home-manager, on top of nixpkgs
          dont-track-me.settings.inputs = {
            nixpkgs = config.inputs.nixpkgs-flake.result;
            home-manager = config.inputs.home-manager.result;
          };
          schizofox.settings.inputs = {
            nixpkgs = config.inputs.nixpkgs-flake.result;
            home-manager = config.inputs.home-manager.result;
          };

          nilla-cli = forceOurNixpkgs;
          nilla-utils = forceOurNixpkgs;
        }
        // nixpkgsOverrides;

      generators.project.folder = ./.;
      generators.nixos.args = {
        homeModules = config.modules.home;
      };
    };
  }
)
