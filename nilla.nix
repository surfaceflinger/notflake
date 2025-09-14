let
  pins = import ./npins;

  nilla = import pins.nilla;
in
nilla.create (
  { config }:
  {
    includes = [ "${pins.nilla-utils}/modules" ];

    config = {
      generators.inputs.pins = pins;
      inputs = {
        nixpkgs.settings = {
          configuration.allowUnfree = true;
          overlays = [ config.overlays.default ];
        };

        # we need nixpkgs loaded as a flake to use it for overriding nixpkgs inputs
        nixpkgs-flake = {
          inherit (config.inputs.nixpkgs) src;
          loader = "flake";
        };

        # need specific opentofu/terragrunt versions
        nixpkgs-tofu.loader = "flake";

        # these inputs offer only nixos modules so
        # we can just import relevant default.nix files
        agenix.loader = "raw";
        nixos-hardware.loader = "raw";
        srvos.loader = "raw";

        # override inputs
        grapevine.settings.inputs.nixpkgs = config.inputs.nixpkgs-flake.result;
        home-manager.settings.inputs.nixpkgs = config.inputs.nixpkgs-flake.result;
        nix-index-database.settings.inputs.nixpkgs = config.inputs.nixpkgs-flake.result;
        schizofox.settings.inputs.nixpkgs = config.inputs.nixpkgs-flake.result;
        tf.settings.inputs.nixpkgs = config.inputs.nixpkgs-flake.result;
        tgexpiry.settings.inputs.nixpkgs = config.inputs.nixpkgs-flake.result;
        xkomhotshot.settings.inputs.nixpkgs = config.inputs.nixpkgs-flake.result;
      };

      generators.project.folder = ./.;
      generators.nixos.args = {
        homeModules = config.modules.home;
      };
    };
  }
)
