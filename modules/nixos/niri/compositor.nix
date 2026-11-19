{ inputs, pkgs, ... }:
let
  niriPkg = inputs.niri-flake.result.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable;
in
{
  environment.systemPackages = [
    niriPkg
    pkgs.nautilus
  ];

  services.displayManager = {
    sessionPackages = [ niriPkg ];
    defaultSession = "niri";
  };
}
