{ inputs, pkgs, ... }:
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

  home.packages = with pkgs; [ safe-rm-nat ];

  nix.gc = {
    automatic = true;
    frequency = "weekly";
    randomizedDelaySec = "10min";
    options = "--delete-older-than 7d";
  };
}
