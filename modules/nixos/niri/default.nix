{ homeModules, ... }: {
  imports = [
    ./compositor.nix
    ./ly.nix
    ./portal.nix
    ./lock.nix
  ];

  home-manager.users.nat.imports = [ homeModules.niri ];
}
