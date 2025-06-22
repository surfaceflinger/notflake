{
  inputs,
  osConfig,
  pkgs,
  ...
}:
{
  imports = [
    ./git.nix
    inputs.dont-track-me.result.homeManagerModules.default
    inputs.nix-index-database.result.hmModules.nix-index
  ];

  home.stateVersion = osConfig.system.stateVersion;

  dont-track-me = {
    enable = true;
    enableAll = true;
  };

  home.packages = with pkgs; [
    safe-rm-nat
  ];

  nix.gc = {
    automatic = true;
    frequency = "weekly";
    randomizedDelaySec = "10min";
    options = "--delete-older-than 7d";
  };
}
