{ inputs, ... }: {
  imports = [
    ./git.nix
    inputs.dont-track-me.result.homeManagerModules.default
    inputs.nix-index-database.result.homeModules.nix-index
  ];

  home.stateVersion = "26.05";

  dont-track-me = {
    enable = true;
    enableAll = true;
  };

  # HashiCorp tools (packer) phone home through checkpoint
  home.sessionVariables.CHECKPOINT_DISABLE = "1";

  nix.gc = {
    automatic = true;
    randomizedDelaySec = "10min";
    options = "--delete-older-than 7d";
  };
}
