{ inputs, pkgs, ... }:
let
  niriPkg = inputs.niri.result.packages.${pkgs.stdenv.hostPlatform.system}.niri;
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
