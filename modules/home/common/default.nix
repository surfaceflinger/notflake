{ inputs, ... }:
{
  imports = [
    ./git.nix
    inputs.dont-track-me.result.homeManagerModules.default
    inputs.nix-index-database.result.homeModules.nix-index
  ];

  home.stateVersion = "24.11";

  dont-track-me = {
    enable = true;
    enableAll = true;
  };

  nix.gc = {
    automatic = true;
    randomizedDelaySec = "10min";
    options = "--delete-older-than 7d";
  };
}
