{ homeModules, inputs, ... }: {
  imports = [
    inputs.niri-flake.result.nixosModules.binary-cache
    ./compositor.nix
    ./ly.nix
    ./portal.nix
    ./lock.nix
  ];

  home-manager.users.nat.imports = [ homeModules.niri ];
}
